# SAP CF 自动保活脚本

本脚本用于在 SAP BTP Cloud Foundry 中自动保活应用，每天按 UTC 时间在 **0:15、0:35、0:55** 自动执行保活操作。

---

## 需要的 Secrets

| Secret 名称      | 说明 |
|-----------------|--------------------------------------------------|
| `CF_USERNAME`    | 你的 SAP BTP Cloud Foundry 登录用户名（通常是邮箱） |
| `CF_PASSWORD`    | 你的 Cloud Foundry 登录密码 |
| `CF_API`         | Cloud Foundry API endpoint，例如：`https://api.cf.ap21.hana.ondemand.com` |
| `CF_ORG`         | 你的组织名 (Org) |
| `CF_SPACE`       | 你的空间名 (Space) |
| `CF_APP`         | 你要保活的应用名称 (App name) |

---

## 配置方法

1. 打开 GitHub 仓库 → **Settings** → **Secrets and variables** → **Actions**。
2. 点击 **New repository secret**，依次添加上面列出的 Secrets。
3. **注意**：名称必须和 workflow 文件里一致（例如 `CF_USERNAME`）。
4. 值就是你在 SAP BTP Cloud Foundry 上对应的参数。

---

## 查询参数命令

```bash
cf t
cf a
```

---

# sap.sh 使用说明

sap.sh 是用于在 VPS / 本地服务器 上运行的 SAP Cloud Foundry 应用自动保活脚本，可替代 GitHub Actions，避免定时任务不准时的问题。

---

##  一、功能说明

sap.sh 主要完成以下工作：
登录 SAP BTP Cloud Foundry
设置应用健康检查方式为 process
检查目标应用运行状态
当应用 未处于 running 状态 时自动执行 cf start
支持配合 cron 定时执行，实现长期稳定保活

---

## 二、运行环境要求

Linux VPS（推荐 Ubuntu / Debian）
已安装 Cloud Foundry CLI
服务器可正常访问 SAP CF API

安装 CF CLI（如未安装）:

```bash
sudo apt update
sudo apt install -y wget
wget -q -O cf-cli.deb "https://packages.cloudfoundry.org/stable?release=debian64&source=github"
sudo dpkg -i cf-cli.deb
```

验证安装：

```bash
cf -v
```

---

## 三、sap.sh 配置方法

1️⃣ 编辑 sap.sh 文件：

```bash
nano sap.sh
```

2️⃣ 填写你的 Cloud Foundry 信息（示例）：

```bash
CF_API="https://api.cf.ap21.hana.ondemand.com"
CF_USERNAME="your_email@example.com"
CF_PASSWORD="your_password"
CF_ORG="your_org"
CF_SPACE="your_space"
CF_APP="your_app_name"
```

⚠️ 注意：

请确保以上变量与 SAP BTP 中的信息完全一致

账号密码仅保存在你自己的 VPS 上，不经过第三方平台

---

## 四、赋予执行权限

```bash
chmod +x sap.sh
```

---

## 五、手动运行测试（推荐先执行一次）

```bash
./sap.sh
```

如果配置正确，你会看到应用状态检查与启动日志输出。

## 六、配合 cron 实现自动保活（推荐）

编辑 crontab：

```bash
crontab -e
```

按 UTC 时间 每天 0:15 / 0:35 / 0:55 执行：

```bash
15,35,55 0 * * * /root/sap.sh
```
