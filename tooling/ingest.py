#!/usr/bin/env python3
"""
Combined ingestion script for JSON-LD -> Terraform or Bicep outputs.

Usage:
  python tooling/ingest.py --target terraform
  python tooling/ingest.py --target bicep

This reuses the same extraction logic and provides two small writer functions.
"""
import json
import argparse
from pathlib import Path
import sys


def load_definition(path: Path) -> dict:
    with path.open('r', encoding='utf-8') as f:
        return json.load(f)


def extract_storage_account(defn: dict) -> dict:
    sa = {}
    sku = defn.get('az:sku') or {}
    sa['sku_tier'] = sku.get('az:tier')
    sa['access_tier'] = defn.get('az:accessTier')
    sa['accountReplication'] = defn.get('az:accountReplication')
    sa['publicNetworkAccess'] = defn.get('az:publicNetworkAccess')
    sa['allowBlobPublicAccess'] = defn.get('az:allowBlobPublicAccess')
    sa['blobSoftDeleteRetentionDays'] = defn.get('az:blobSoftDeleteRetentionDays')

    # Require at least 'sku_tier' and 'accountReplication'
    required = [k for k in ('sku_tier', 'accountReplication') if not sa.get(k)]
    if required:
        raise ValueError(f"Missing required properties in definition: {required}")

    return sa


# Configuration writer for Terraform
def write_terraform(outdir: Path, values: dict):
    outdir.mkdir(parents=True, exist_ok=True)
    out_path = outdir / 'storage_account.auto.tfvars'
    with out_path.open('w', encoding='utf-8') as f:
        for k, v in values.items():
            if isinstance(v, bool):
                f.write(f'{k} = {str(v).lower()}\n')
            elif isinstance(v, (int, float)):
                f.write(f'{k} = {v}\n')
            else:
                f.write(f'{k} = "{v}"\n')
    print(f'Wrote tfvars to: {out_path}')


# Configuration writer for Bicep
def write_bicep(outdir: Path, values: dict):
    outdir.mkdir(parents=True, exist_ok=True)
    out_file = outdir / 'main.bicepparam'
    with out_file.open('w', encoding='utf-8') as f:
        f.write("using 'main.bicep'\n\n")
        for k, v in values.items():
            if isinstance(v, bool):
                f.write(f'param {k} = {str(v).lower()}\n')
            elif isinstance(v, (int, float)):
                f.write(f'param {k} = {v}\n')
            else:
                f.write(f'param {k} =\'{v}\'\n')
    print(f'Wrote Bicep params to: {out_file}')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--definition', default='definitions/storage_account.jsonld') # Path to JSON-LD definition
    args = parser.parse_args()

    base = Path(__file__).resolve().parent.parent
    def_path = base / args.definition
    if not def_path.exists():
        print(f"Definition file not found: {def_path}")
        sys.exit(2)

    defn = load_definition(def_path)
    sa = extract_storage_account(defn)

    # Write configuration files for Terraform and Bicep
    write_terraform(base / 'terraform', sa)
    write_bicep(base / 'bicep', sa)


if __name__ == '__main__':
    main()
