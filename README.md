# Resume

Automatically build and publish your LaTeX resume to a custom subdomain, while archiving previous versions in [Cloudflare R2](https://www.cloudflare.com/en-in/developer-platform/products/r2/).


## Quick Start

### 1. Fork and Clone
```bash
git clone https://github.com/shaiq-dev/resume.git
cd resume
```

Edit the LaTeX template in the `src` directory, or replace it with your own. If your LaTeX file uses additional packages, make sure to add them to the `Dockerfile`.

### 2. Setup Cloudflare
```bash
# Install Wrangler CLI and login to cloudflare
npm install -g wrangler

wrangler login

# Create R2 bucket
wrangler r2 bucket create <your-resume-storage>
```

Update your custom subdomain in `wrangler.toml`. The domain must already be added to your Cloudflare account. See Cloudflare [documentation](https://developers.cloudflare.com/fundamentals/manage-domains/add-site/) for instructions on adding domains.

### 3. Configure GitHub Actions
GitHub Actions requires the following secrets to deploy the Cloudflare Worker and upload your resume to R2:

```bash
# Required by Wrangler as documented here:
# https://github.com/cloudflare/wrangler-action?tab=readme-ov-file#i-just-started-using-workerswrangler-and-i-dont-know-what-this-is
# https://developers.cloudflare.com/fundamentals/account/find-account-and-zone-ids/
CLOUDFLARE_ACCOUNT_ID=

# Token with permissions to deploy Worker scripts.
# Permissions required:
#   Account-level:
#     - Workers Builds Configuration:Edit
#     - Workers Scripts:Edit
#     - Account Settings:Read
#   Domain-level:
#     - Workers Routes:Edit
#     - DNS:Edit
CLOUDFLARE_API_TOKEN=

# R2 implements the S3 API, compatible with AWS SDK.
# https://developers.cloudflare.com/r2/api/tokens/
CLOUDFLARE_R2_ACCESS_KEY_ID=
CLOUDFLARE_R2_SECRET_ACCESS_KEY=
CLOUDFLARE_R2_ENDPOINT=
```

<br />

## Local Build 
You can build the resume locally using Docker without installing LaTeX or TeX Live on your machine.

```bash
./build.sh
```

<br />

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
