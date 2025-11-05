🍕 피자 프로젝트 인프라 (Terraform)
이 저장소는 '피자 주문 플랫폼' 애플리케이션을 운영하기 위한 모든 Google Cloud Platform (GCP) 인프라를 Terraform 코드로 관리합니다.

이 코드는 애플리케이션(백엔드, 프론트엔드), 데이터 파이프라인(Airflow, Spark), 데이터베이스에 필요한 네트워크, GKE 클러스터, Cloud SQL 등을 자동으로 프로비저닝합니다.

🏗️ 핵심 아키텍처 및 프로비저닝되는 리소스
본 Terraform 코드는 여러 모듈로 구성되어 있으며, main.tf 파일이 이 모듈들을 조합하여 전체 인프라를 생성합니다.

🌐 module "vpc" (네트워킹)

애플리케이션과 GKE를 위한 커스텀 VPC 및 서브넷을 생성합니다.

GKE Pods, Services를 위한 별도의 IP 범위를 할당합니다.

GKE 노드(Private)가 외부 인터넷에 접근할 수 있도록 Cloud NAT 및 Cloud Router를 구성합니다.

☸️ module "gke" (Kubernetes)

애플리케이션(Django, React 등)과 Airflow가 배포될 GKE(Google Kubernetes Engine) 클러스터를 생성합니다.

depends_on을 통해 VPC 및 서브넷이 먼저 생성된 후 클러스터가 생성되도록 보장합니다.

🐘 module "rdb" (데이터베이스)

Django 백엔드 또는 Airflow 메타데이터 DB로 사용될 Cloud SQL (PostgreSQL/MySQL) 인스턴스를 생성합니다.

db-f1-micro 사양으로 생성되며 VPC와 비공개(Private)로 연결됩니다.

🔑 module "workload_identity" (권한)

GKE 클러스터 내의 Pod(예: Spark, Airflow)가 GCP 리소스(예: GCS, BigQuery)에 안전하게 접근할 수 있도록 Workload Identity를 설정합니다.

GCP Service Account(GSA)와 Kubernetes Service Account(KSA)를 바인딩하고 roles/storage.admin 권한을 부여합니다.

🔌 provider "kubernetes" 및 provider "helm"

GKE 클러스터가 생성된 후에 해당 클러스터의 정보를 (data 블록으로) 읽어와 Kubernetes 및 Helm 프로바이더를 인증합니다.

이를 통해 ArgoCD, Airflow, Spark Operator 등을 Helm 차트로 배포할 수 있습니다.

```
🗂️ 디렉터리 구조
.
├── 📂 modules/                # 개별 인프라 모듈
│   ├── 📂 gke/                # GKE 클러스터 모듈
│   ├── 📂 rdb/                # Cloud SQL 모듈
│   ├── 📂 vpc/                # VPC 네트워크 모듈
│   └── 📂 workload_identity/  # Workload Identity 모듈
│
├── 📜 main.tf                 # 루트 모듈 (모든 모듈 조합)
├── 📜 variables.tf            # 입력 변수 (project_id, region 등)
├── 📜 outputs.tf              # 생성된 리소스 정보 출력 (예: GKE Endpoint)
├── 📜 terraform.tfvars.example # 변수 예시 파일
└── 📜 README.md
```
