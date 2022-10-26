# tg-group-profile-manager
This project deploys a Slackbot which provide Twingate users to manage their own group profile.

## Prerequisite
1. Slack Workspace
2. [Twingate](https://www.twingate.com/) account

## Set Up Steps
### Slack App Initial Setup
1. Create New Slack app from a manifest [here](https://api.slack.com/apps)
2. Paste the content from [manifest.yaml](https://github.com/Twingate-Labs/tg-group-profile-manager/blob/main/manifest.yml)
3. Install the Slack app to your Workspace
4. Retrieve the signing secret from Basic Info and bot token at OAuth & Permissions

### (Option 1) Deploy as Docker
1. Clone the latest tg group profile manager `git clone https://github.com/Twingate-Labs/tg-group-profile-manager.git`
2. `cd tg-group-profile-manager`
3. Populate `tg-group-profile-manager.conf`
   - `SLACK_SIGNING_SECRET=xxx` can be found at the page "Basic Information" in Slack API app page
   - `SLACK_BOT_TOKEN=xxx` can be found at page "OAuth & Permissions"
   - `TG_API_KEY=xxx` can be generated in the Setting page within the Twingate Admin Console (Read, Write & Provision Token is required)
   - `TG_ACCOUNT=xxx.twingate.com` replace with your Twingate Network Address
   - `PROFILE_CONFIG` 
     - profiles: List of Object, where each Object defines a group profile
     - profileName: User friendly group profile name
     - groups: List of Twingate groups within the profile which the users can switch to
     - applicableToGroup: A Twingate group which the users within it can access the group profile
   - `DEPLOY_ENV=docker`
4. Build Docker container `docker build . -t tg-group-profile-manager`
5. Run Docker container `docker run -p 8080:8080 -d --name tg-group-profile-manager tg-group-profile-manager`
6. Now you have the `tg-group-profile_manager` running

### (Option 2) Deploy as Google Cloud Run
1. Open Google [Cloud Shell](https://cloud.google.com/shell)
2. Clone the project `git clone https://github.com/Twingate-Labs/tg-group-profile-manager.git`
3. Populate `tg-group-profile-manager.conf`
    - `SLACK_SECRET` can be found at the page "Basic Information" in Slack API app page
    - `SLACK_BOT_TOKEN` can be found at page "OAuth & Permissions"
    - `TG_API_KEY` can be generated in the Setting page within the Twingate Admin Console (Read and Write Token is required)
    - `TG_ACCOUNT` replace with your Twingate Network Address (e.g. test1.twingate.com)
    - `PROFILE_CONFIG` see example at [tg-group-profile-manager.conf](https://github.com/Twingate-Labs/tg-group-profile-manager/blob/main/tg-group-profile-manager.conf)
        - profiles: List of Object, where each Object defines a group profile
        - profileName: User friendly group profile name
        - groups: List of Twingate groups within the profile which the users can switch to
        - applicableToGroup: A Twingate group which the users within it can access the group profile, set to 'Everyone' to give all Twingate users the access to the group profile
4. Execute the following commands
```
cd tg-group-profile-manager
gcloud config set compute/zone europe-west2-a # change to your preferred zone
gcloud config set run/region europe-west2 # change to your preferred region
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export SERVICE_ACCOUNT=$(gcloud iam service-accounts list --format 'value(EMAIL)' --filter 'NAME:Compute Engine default service account')
./cloudrun_setup.sh
```
4. Copy out the URL of the Slack app, e.g. `https://tg-group-profile-manager-xxxxx-nw.a.run.app`
5. (Optional) Improve Performance
   * The Cloud Run can take between 5-10 seconds to process the switch group requests with the default Cloud Run configuration
   * (Recommended) [CPU is always allocated](https://cloud.google.com/run/docs/configuring/cpu-allocation#setting) can be enabled in Cloud Run to improve performance (to 1-2 seconds)
   * (Alternatively) Cloud Run [CPU boost](https://cloud.google.com/blog/products/serverless/announcing-startup-cpu-boost-for-cloud-run--cloud-functions) can be enabled in Cloud Run, but the improvement is not as significant as [CPU is always allocated](https://cloud.google.com/run/docs/configuring/cpu-allocation#setting)

### Finishing Setup in Slack App UI
1. Go to your app at [Slack App UI](https://api.slack.com/apps)
3. Event Subscription
   * Replace the Request URL to `https://{Your tg-group-profile-manager Address}/slack/events`
* Interactivity & Shortcuts
   * Replace the Request URL to `https://{Your tg-group-profile-manager Address}/slack/events`
4. Download the [Twingate Logo](https://github.com/Twingate-Labs/tg-group-profile-manager/blob/main/Twingate%20Logo%20-%20Icon.png) and change the logo of the Slack app at the Basic Info

### Limitations
1. When there are Twingate groups with duplicate names, only the first group returned by the Twingate API is used. To prevent this, ensure there are no duplicate group names in the Twingate network.
2. If a user is part of more than 50 Twingate groups, only the first 50 Twingate groups returned by the Twingate API is used. To prevent this, ensure there are no users part of more than 50 groups in the Twingate network.
3. The Slack users' email addresses need to be the same as their Twingate email addresses.