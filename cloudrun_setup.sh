#!/bin/sh
set -a
. ./tg-group-profile-manager.conf
set +a
gcloud services enable secretmanager.googleapis.com
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=user:$(gcloud auth list --format 'value(account)') --role=roles/secretmanager.admin
echo -n $BOT_TOKEN | gcloud secrets create tg-group-profile-manager-bot-token --replication-policy=automatic --data-file=-
echo -n $SIGNING_SECRET | gcloud secrets create tg-group-profile-manager-client-signing-secret --replication-policy=automatic --data-file=-
echo -n $TG_API_KEY | gcloud secrets create tg-group-profile-manager-tg-api-key --replication-policy=automatic --data-file=-
echo -n $TG_ACCOUNT | gcloud secrets create tg-group-profile-manager-tg-account --replication-policy=automatic --data-file=-
echo -n $PROFILE_CONFIG | gcloud secrets create tg-group-profile-manager-profile-config --replication-policy=automatic --data-file=-