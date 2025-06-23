set -a 
source ./.env
set +a 

echo "Setting Gcloud Project to... $PROJECT_ID"
gcloud config set project $PROJECT_ID
gcloud services enable compute.googleapis.com
gcloud services enable iam.googleapis.com