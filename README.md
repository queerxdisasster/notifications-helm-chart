# 🚀 notifications-stack

Полное руководство по запуску проекта **notifications-stack** в Kubernetes с помощью Helm и Docker.

## 📋 О проекте

Данный проект содержит:

- Java-сервис уведомлений (Spring Boot);
- Apache Ignite (персонализированный образ);
- PostgreSQL;
- Мониторинг (Prometheus + Grafana);
- Nginx Ingress Controller.

---

## 🛠 Предварительные требования

- Kubernetes-кластер;
- Установленные инструменты:
  - `docker` >= 20.10
  - `helm` >= 3.10
  - `kubectl` >= 1.25

Проверка:

```bash
docker -v
helm version
kubectl version
```

---

## 📈 Установка мониторинга (Prometheus + Grafana)

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  -f helm/monitoring-values.yaml \
  --namespace monitoring --create-namespace
```

---

## 🌐 Установка Ingress-контроллера (Nginx)

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

---

---

## 🚩 Запуск основного Helm-чарта

```bash
helm dependency update helm/notifications-helm-chart

helm upgrade --install notifications helm/notifications-helm-chart \
  --namespace notifications --create-namespace
```

Дождитесь запуска всех подов:

```bash
kubectl get pods -n notifications
```

---

## ✅ Проверка работы

| Описание                | Запрос                                                     |
|-------------------------|------------------------------------------------------------|
| Здоровье сервиса        | `curl http://b1.local/actuator/health`                    |
| Swagger UI              | `http://b1.local/swagger-ui.html`                          |
| WebSocket               | `ws://b1.local/ws?orgIds=123&roles=USER&empNumber=456`     |
| Prometheus-метрики      | `curl http://b1.local/actuator/prometheus`                |
| Grafana                 | `kubectl -n monitoring port-forward svc/grafana 3000:80`   |
|                         | Затем открыть [http://localhost:3000](http://localhost:3000) (admin/prom) |

---

## 📌 Масштабирование и обновление

Изменение числа реплик:

```bash
helm upgrade notifications helm/notifications-helm-chart \
  --set replicaCount=4 -n notifications
```

---

## ❌ Удаление проекта

```bash
helm uninstall notifications -n notifications
kubectl delete namespace notifications
```

---

🎉 **Готово!** Ваш сервис уведомлений полностью развёрнут и готов к работе.
