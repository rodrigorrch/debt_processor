# **Documentação do Projeto**

Este repositório contém a implementação de um sistema escalável para processamento e geração de registros financeiros a partir de arquivos CSV. Ele inclui uma arquitetura baseada em Redis, Sidekiq, processamento em chunks e cobertura de testes unitários e de integração.

---
## **Subir o projeto**
`docker-compose build`
`docker-compose up -d`
`docker-compose exec web rails db:create db:migrate`
`docker-compose exec web bin/rails db:test:prepare`

### **Apis e monitoramento**
Temos 2 API`s:
Nesta api enviamos o arquivo
`curl --location 'localhost:3000/api/v1/debts/upload' \
--header 'Content-Type: multipart/form-data' \
--form 'file=@"/C:/Users/rodri/Documents/Kanastra/input.csv"'`

Nesta api monitoramos o status:
`curl --location 'localhost:3000/api/v1/debts/status/{id}'`

Também podemos monitorar a fila por este link
`http://localhost:3000/sidekiq/`

## **Escalabilidade**

### **Redis + Sidekiq**
- Permite múltiplos workers processarem tarefas simultaneamente.
- Utiliza filas distribuídas via Redis.
- Suporte à escalabilidade horizontal ao adicionar mais workers.

### **Processamento em Chunks**
- O arquivo CSV é processado linha por linha, garantindo eficiência de memória.
- O sistema não carrega o arquivo inteiro na memória, otimizando recursos.
- Cada dívida no CSV é processada de forma independente, facilitando o paralelismo.

---

## **Pontos de Escalabilidade**
1. **Processamento assíncrono**: Uso de Sidekiq para tarefas longas.
2. **Divisão de dados**: Processamento eficiente de grandes arquivos CSV.
3. **Integração com Redis**: Suporte robusto a filas de mensagens.

---

## **Testes**

### **Testes Unitários**
#### **Models**
- **`spec/models/bill_spec.rb`**
  - Testes de validações.
  - Testes de enums.
  - Testes de associações.
- **`spec/models/debt_spec.rb`**
  - Testes de validações.
  - Testes de associações.
- **`spec/models/file_processing_spec.rb`**
  - Testes de validações.
  - Testes de enums.
  - Testes de associações.

#### **Services**
- **`spec/services/email_sender_spec.rb`**
  - Mock do **`Rails.logger`** para testar apenas a lógica da classe.
  - Testes isolados de atualização de status.
  - Testes de cenários de erro.

---

### **Testes de Integração**
#### **Workers**
- **`spec/workers/bill_generation_worker_spec.rb`**
  - Testa a integração entre Worker, Debt, BillGenerator e EmailSender.
  - Valida o fluxo completo de geração de bills.
  - Verifica integração com Sidekiq.
- **`spec/workers/file_processing_worker_spec.rb`**
  - Testa a integração entre Worker, FileProcessing e DebtFileProcessor.
  - Valida integração com ActiveStorage e Sidekiq.

#### **Services**
- **`spec/services/debt_file_processor_spec.rb`**
  - Testa o processamento real de arquivos CSV.
  - Valida a criação de múltiplos registros no banco.
  - Verifica a integração entre FileProcessing e Debt.

---

## **Como acompanhar o progresso**
- Utilize o endpoint de status para verificar o andamento das tarefas assíncronas.

---

Este sistema foi projetado para ser robusto, escalável e confiável, atendendo a demandas de alto volume de dados e processamento eficiente.
