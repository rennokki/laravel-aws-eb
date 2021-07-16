# Laravel Elastic Beanstalk

Laravel EB is a sample configuration to help you deploy a Laravel app on an AWS Elastic Beanstalk PHP environment without any super rockety-like knowledge.

## 🤝 Supporting

Renoki Co. loves building open source (and helpful) projects on Github for any developer to have an easier job at building products. 📦 Developing and maintaining projects is a harsh job and tho, we love it.

If you are using your application in your day-to-day job, on presentation demos, hobby projects, or even school projects, spread some kind words about our work or sponsor our work.

_Kind words will touch our chakras and vibe, while the sponsorships will keep the open-source projects alive._

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/R6R42U8CL)

# Amazon Linux 2

This branch is working with the new Amazon Linux 2.

It's highly recommended to upgrade to the Amazon Linux 2 version, since it's faster and more secure. ([see AWS's announcement](https://aws.amazon.com/about-aws/whats-new/2020/04/aws-elastic-beanstalk-announces-general-availability-of-amazon-linux-2-based-docker-corretto-and-python-platforms/))

To upgrade to AL2 from your Amazon Linux AMI, please see the [Amazon Linux 2 migration guide](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.migration-al.html)

If you still work with Amazon Linux AMI, please switch to the [amazon-ami branch](../../tree/amazon-ami) to read the older docs.

# Packaged

The sample configuration comes with:

- Automation for copying .env file from AWS EB's S3 bucket (so you won't have to add the env variables from the AWS Console)
- Laravel Artisan Scheduler CRON configuration
- Supervisor for Queues
- HTTP to HTTPS support
- Nginx configuration support
- Chromium binary

# Updating

The repo works with semantic versioning, so please check the [Releases](../../releases) page for latest updates & changes.

# Installation

Clone the repo and drop the `.ebextensions` and `.platform` folders in your root project.

Make sure that the .sh files from the `.platform` folder are executable before deploying your project:

```bash
$ chmod +x .platform/hooks/prebuild/*.sh
```

```bash
$ chmod +x .platform/hooks/predeploy/*.sh
```

```bash
$ chmod +x .platform/hooks/postdeploy/*.sh
```

```bash
$ chmod +x .platform/scripts/*.sh
```

# AWS EB Should-Know

## Deployment Stages

Elastic Beanstalk helps you deploy apps while keeping them up, so you won't have to turn your app down during deployments. For this, there are two paths:

- `/var/app/staging` that holds the app between deployments. This folder is not pointed to until the deployment finishes
- `/var/app/current` that holds the live app and that serves requests actively

Each deploy makes you lose everything you have in the `current` folder. **DO NOT** rely on local storage, use S3 instead with CloudFront to avoid data loss and speed up the things.

## .ebextensions/

The `.ebextensions` folder contains information about which commands to run during the deployment, such as migrations or copying files in the instance.

In this repo, see `01_deploy.config` for a list of commands that will be ran upon deployment.

On the other hand, the `00_copy_env_file.config` will copy the `.env` file from your S3 bucket and put it temporarily in the `/tmp` folder, to later be copied in the deployment process.

Please open the files to see further comments on the particular sections and change them.

## .platform/

The `.platform` folder contains mostly shell scripts that will be ran during the deployment, like configuring or installing software, like supervisor, or running scripts after the deployment finished.

Consider looking in the `files/` folder for Supervisor and PHP custom configurations that will be automatically be applied, out-of-the-box.

Additionally, the `hooks/`folder contains scripts that will be ran during various deployment stages. All scripts contain comments about details and best practices, so take a look.

Please refer to this scheme to understand the execution workflow: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/images/platforms-linux-extend-order.png

# Use Cases

## HTTP to HTTPS

Check the `.platform/nginx/conf.d/elasticbeanstalk/https.conf` file to enable HTTP to HTTPS redirect.

## Laravel Passport

Since Laravel Passport uses local storage to keep the public and private key, there is no way of using this method. Instead, you might use what this PR added: https://github.com/laravel/passport/pull/683

In your `.env` file, add the following variables **and make sure that there is a `\\n` for each newline**:

```
PASSPORT_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----\\nMIIJJwIBAAKCAgEAw3KPag...\\n-----END RSA PRIVATE KEY-----"
PASSPORT_PUBLIC_KEY="-----BEGIN PUBLIC KEY-----\\nMIICIjANBgkqhkiG9w0BAQEFAAOC...\\n-----END PUBLIC KEY-----\\n"
```

## Spatie Media Library & other Imagick-based packages

Some packages require Imagick to run.

To enable Imagick installation on the instance via Amazon Linux Extras, check `install_imagick.sh` file for details.

## Memcached Auto Discovery

Memcached Auto Discovery for AWS Memcached is a PHP extension that replace the default Memcached extension, in order to use Memcached clusters in multi-node mode.

Plese see `install_memcached_discovery.sh` file to enable the installation for your PHP version.

For the Laravel app, edit your `memcached` connection in `cache.php` to make it suitable for multi-node configuration:

```php
'memcached' => [
    'driver' => 'memcached',
    
    'persistent_id' => env('MEMCACHED_PERSISTENT_ID', 1), // make sure you also set a default to the persistent_id
    
    'options' => array_merge([
        Memcached::OPT_DISTRIBUTION => Memcached::DISTRIBUTION_CONSISTENT,
        Memcached::OPT_LIBKETAMA_COMPATIBLE => true,
        Memcached::OPT_SERIALIZER => Memcached::SERIALIZER_PHP,
    ], in_array(env('APP_ENV'), ['production', 'staging']) ? [
        Memcached::OPT_CLIENT_MODE => Memcached::DYNAMIC_CLIENT_MODE,
    ] : []),
]
```

**For production & staging workloads (when AWS Elasticache is used), `Memcached::OPT_CLIENT_MODE` should be set. `OPT_CLIENT_MODE` and `DYNAMIC_CLIENT_MODE` are Memcached Auto Discovery extension-related constants, not available in the default Memcached extension.**

## Chromium binary support

Some Laravel apps, like crawlers, might need a Chrome binary to run upon. A good example is [spatie/browsershot](https://github.com/spatie/browsershot#custom-chromechromium-executable-path). It lets you take browser screenshots using PHP and a Chromium binary.

To install Chromium, seek for the `install_latest_chromium_binary.sh` script and uncomment the code.

The binary can be then accessed from `/usr/bin/google-chrome-stable`

## Run on Spot Instances

Spot instances are the cheapest EC2 instances from AWS, but they can be terminated
anytime. Please refer to this to understand how they can be used: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances.html

Spot instances can be configured from the console. Check out AWS announcement: https://aws.amazon.com/about-aws/whats-new/2019/11/aws-elastic-beanstalk-adds-support-for-amazon-ec2-spot-instances/

# Multi-environment

Sometimes you might have more than one environment, for example production and staging. Having duplicate configuration can be tricky, but you can workaround this problem by seeking a CloudFromation-like appoach as presented in one of the issues: https://github.com/rennokki/laravel-aws-eb/issues/30#issuecomment-693154271

The idea behind it is to use, for example, `{"Ref": "AWSEBEnvironmentName"}` value to concatenate to the name of the .env file that should be downloaded from S3. This way, you can have `.env.staging-app` if your AWS EB environment is named `staging-app`.

# Deploying from the CI/CD Pipeline

To deploy to the EB environment, you have two choices:

- Archive the ZIP by your own and upload it.
- Pull from git, and use AWS EB CLI in the current folder (with no additional ZIP-ing)

AWS EB CLI make use of `.gitignore` and `.ebignore`. The only pre-configuration you need is to add the following environment variables
to your CI/CD machine:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_EB_REGION`

If you use a dockerized CI/CD pipeline (like Gitlab CI), you can make use of the `renokico/aws-cli:latest` image.

The following commands let you deploy an app on a certain environment within Gitlab CI on tag creation, for example:

```bash
$ git checkout $CI_COMMIT_TAG
```

```bash
$ eb init --region=$AWS_EB_REGION --platform=php [project-name]
```

```bash
$ eb use [environment-name]
```

```bash
$ eb deploy [environment-name] --label=$CI_COMMIT_TAG
```
