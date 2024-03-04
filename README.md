# RNAcentral Mod for Powerpipe

RNAcentral is a collection representing all ncRNA types from a broad range of organisms data using PostgreSQL and Powerpipe.

![image](https://github.com/turbot/powerpipe-mod-rnacentral/blob/rnacentral/docs/rnacentral_dashboard_screenshot.png)

## Overview

Dashboards can help answer questions like:

- How many chemical components are present in the RNAcentral database?
- What is the total count of databases contributing their data to RNAcentral?
- Which databases have the highest number of sequences?
- How are RNA modifications distributed across different types?
- What are the trends in RNA interactions as classified by taxonomic IDs?

## Documentation

- **[Dashboards →](https://hub.powerpipe.io/mods/turbot/rnacentral/dashboards)**

## Installation

Download and install Powerpipe (https://powerpipe.io/downloads). Or use Brew:

```sh
brew install turbot/tap/powerpipe
```

Clone:

```sh
git clone https://github.com/turbot/powerpipe-mod-rnacentral.git
cd powerpipe-mod-rnacentral
```

## Usage

Run the dashboard and connect to the [public RNAcentral Postgres database](https://rnacentral.org/help/public-database) connection string:

```sh
powerpipe server --database postgres://reader:NWDMCE5xdipIjRrp@hh-pgsql-public.ebi.ac.uk:5432/pfmegrnargs
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Powerpipe](https://powerpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #powerpipe on Slack →](https://powerpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Powerpipe](https://github.com/turbot/powerpipe/labels/help%20wanted)
- [RNAcentral Mod](https://github.com/turbot/powerpipe-mod-rnacentral/labels/help%20wanted)