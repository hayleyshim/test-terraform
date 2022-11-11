### How to Create a Service Account for Terraform in GCP (Google Cloud Platform)
### service account에 s3 백엔드 접근하기 위한 권한 추가 : 저장소 관리자, 저장소 개체 관리자, 저장소개체 생성자


### 서비스 계정
### https://cloud.google.com/docs/authentication#service-accounts

$ gcloud auth application-default login

### gcp sa 적용
### https://gmusumeci.medium.com/how-to-create-a-service-account-for-terraform-in-gcp-google-cloud-platform-f75a0cf918d1

### gcp service account
### https://medium.com/@jwlee98/gcp-gke-%EC%B0%A8%EA%B7%BC-%EC%B0%A8%EA%B7%BC-%EC%95%8C%EC%95%84%EB%B3%B4%EA%B8%B0-6%ED%83%84-cloud-iam-%EA%B3%BC-kubernetes-rbac-f02b52cf538e



### https://medium.com/the-telegraph-engineering/binding-gcp-accounts-to-gke-service-accounts-with-terraform-dfca4e81d2a0


### https://cloud.google.com/kubernetes-engine/docs/how-to/iam

### sa 적용해서 cloud storage backend 설정해보기

### https://torbjorn.tistory.com/804


### gke 
### https://yunsangjun.github.io/terraform/2020/11/09/getting-started-terraform.html

### https://github.com/gruntwork-io/terraform-google-gke/blob/master/modules/gke-service-account/variables.tf

### kubectl update
### https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl


