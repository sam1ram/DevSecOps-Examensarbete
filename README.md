# DevSecOps Examensarbete – Komplett Guide

Detta projekt syftar till att förbättra säkerheten i molninfrastruktur med Infrastructure as Code (IaC) via Terraform och Ansible. Det kopplas till NIS2-direktivet, med fokus på säkerhetsstandarder, automatisering och efterlevnad.

---

## 🔧 Förutsättningar (lokalt på din dator)

Installera följande:
- [Visual Studio Code](https://code.visualstudio.com/)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Azure CLI](https://learn.microsoft.com/sv-se/cli/azure/install-azure-cli)
- [Python](https://www.python.org/) + `pip install checkov`
- [Git](https://git-scm.com/)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (Linux/macOS)
- GitHub-konto

# committa ändringar via terminalen
---

## 📦 Steg 1: Klona projektet

```bash
git clone https://github.com/<ditt-användarnamn>/<repo-namn>.git
git clone https://github.com/<sam1ram>/<DevSecOpsEX>.git
cd <repo-namn>
```

---

## 🌐 Steg 2: Skapa testmiljö med Terraform (Azure)

### 1. Logga in i Azure
```bash
az login
```

### 2. Gå till terraform-mappen
```bash
cd terraform/testmiljo
terraform init
terraform plan
terraform apply
```

Detta skapar en osäker miljö i Azure:
- Publik lagring (Storage Account)
- Öppna nätverksinställningar
- En virtuell maskin utan säker konfiguration

---

## 🔐 Steg 3: Skanna koden efter säkerhetsbrister

Installera Checkov:
```bash
pip install checkov
```

Kör skanning:
```bash
checkov -d .
```

---

## 🔁 Steg 4: Lägg till säkerhetslager med Ansible

### 1. Redigera `inventory`-fil (lägg till din VMs IP-adress)

Skapa fil `ansible/inventory`:
```
[azurevm]
<din-vm-ip> ansible_user=examuser ansible_ssh_private_key_file=~/.ssh/id_rsa
```

### 2. Kör playbooken:
```bash
cd ansible
ansible-playbook -i inventory playbooks/secure_vm.yml
```

---

## ⚙️ Steg 5: Automatisera med GitHub Actions

### 1. Koden ligger redan i `.github/workflows/security_scan.yml`

Varje gång du pushar till GitHub:
- Checkov körs automatiskt
- Fel rapporteras i GitHub Actions

---

## 📜 Steg 6: Koppla till NIS2-krav

Fokusera på:
- Art. 21 – Tekniska och organisatoriska åtgärder (CIS Benchmarks, brandvägg)
- Art. 23 – Incidentreducering (automatiserad hårdning minskar risken)
- Art. 20 – Riskhantering via IaC

---

## 📊 Steg 7: Dokumentera resultat och effekter

Beskriv:
- Antal sårbarheter innan/efter
- Tidsvinster med automatisering
- Hur projektet bidrar till DevSecOps

---

## 📝 Rapportmall

1. Inledning – syfte, bakgrund, mål
2. Metod – verktyg, tekniker, process
3. Implementering – terraform, ansible, CI/CD
4. Resultat – vad förbättrades, vad identifierades
5. Diskussion – vad kunde gjorts bättre, framtida förbättringar
6. Slutsats – summering + koppling till NIS2
7. Bilagor – kodexempel, skärmdumpar, referenser

---

## 🎤 Presentation

- Skapa en PowerPoint
- Beskriv före/efter säkerhet
- Visa CI/CD och terraform-resultat
- Lyft fram din NIS2-koppling

---

## 💡 Inkludera detta vid tillfälle - viktigt för högre betyg

- Implementera Sentinel eller OPA för policy enforcement
- Reflektera över branschnytta i din rapport
- Skapa en demo-video eller GIF av din pipeline
