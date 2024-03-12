# Resume - _Devopsified_ 🛠

Auto publish your new resume to a custom subdomain and save the old iterations in S3.

### Deploy your own
- Clone the repo and modify the latex template inside the `src` dir or add your own latex template there. If you are adding a new template, make sure to modify the [action](https://github.com/shaiq-dev/resume/blob/main/.github/workflows/upload-to-s3.yml#L21) file to include any new dependencies.

- For authenticating GitHub actions with AWS, I am using OIDC-standard short-term credentials authentication. Follow this amazing [guide](https://dev.to/slsbytheodo/configure-authentication-to-your-aws-account-in-your-github-actions-ci-13p3) to setup on your account. 
<br /> 
[See also](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/) this one from aws/

- The iam role assigned to GitHub actions, uses following policy.
  ```json
  {
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"cloudformation:*",
				"s3:*",
				"lambda:*",
				"apigateway:*",
				"iam:Get*",
				"iam:List*",
				"iam:Create*",
				"iam:Update*",
				"iam:PassRole",
				"iam:AttachRolePolicy",
				"iam:DetachRolePolicy",
				"iam:PutRolePolicy",
				"iam:DeleteRolePolicy",
				"iam:DeleteRole",
				"acm:*"
			],
			"Resource": [
				"*"
			]
		}
	]
  }
  ```

- Change the storage bucket name [here](https://github.com/shaiq-dev/resume/blob/main/deploy/stacks/storage.yml#L8). Also update the domain name [here](https://github.com/shaiq-dev/resume/blob/main/deploy/stacks/lambda.yml#L54) and subdomain you want to add [here](https://github.com/shaiq-dev/resume/blob/main/deploy/stacks/lambda.yml#L60), to get a certificate from AWS ACM for api gateway domain.

- My domain is from Namecheap and I didn't wanted to use Route53 DNS (If you have Route53 DNS you can automate ACM certificate verification), so when the stack runs, AWS ACM sends a verification email to the domain admin, after verifying that, the stack creation completes.

- Last step is to add an `ALIAS` record in your DNS settings, where host is your subdomain and value is the Api gateway domain name.

- Wait for DNS propogation and ✨🥳✨. Accesssing your subdomain will redirect to your latest resume.