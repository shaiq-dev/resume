# DResume

[![Publish Resume](https://github.com/shaiq-dev/Resume/actions/workflows/publish.yml/badge.svg?branch=main)](https://github.com/shaiq-dev/Resume/actions/workflows/publish.yml)

The resume is written in latex and uses **`Alta CV`** template. Devops part is based on the following architecture.

![AWS Architecture](https://miro.medium.com/max/1252/1*C-KCbCECdL0Vh5bfgTiafg.jpeg)

On each commit to main branch, a new CodeBuild deployment is created via GitHub actions. CodeBuild copies the changes to EC2 and runs some hooks defined in `appspec.yml`. 

The **build** hook compiles the latex source code into a pdf and **process_doc** upload the pdf to a S3 bucket.

**Handlres** folder has a lambda function that fetches the latest resume from the S3 bucket and returns a S3 signed url for it. The lambda function is used with github pages (Check the [gh-pages](https://github.com/shaiq-dev/Resume/tree/gh-pages) branch).

I have written a complete tutorial on [medium](https://shaiqkar.medium.com/) for this project. [Check that out](https://shaiqkar.medium.com/build-a-devopsified-resume-with-github-and-aws-21c0e38df1c4)