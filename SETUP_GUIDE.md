# 安装分发设置总结

## 已完成的工作

### ✅ 1. 自动化构建和发布

**文件：** `.github/workflows/release.yml`

功能：
- 自动构建多平台二进制文件（Linux/macOS, amd64/arm64）
- 创建 GitHub Release
- 自动生成 Release Notes
- 更新 Homebrew Tap（需要配置）

### ✅ 2. Debian 包支持

**文件：** `.github/workflows/build-deb.yml` 和 `Cargo.toml`

功能：
- 使用 `cargo-deb` 构建 .deb 包
- 配置了包的元数据
- 可以发布到 APT 仓库

### ✅ 3. Homebrew Formula

**文件：** `cte.rb` (用于发布到 homebrew-tap)

功能：
- 定义了 Homebrew 安装配方
- 包含测试用例
- 自动从源码编译安装

### ✅ 4. 安装脚本

**文件：** `scripts/install.sh`

功能：
- 自动检测操作系统和架构
- 从 GitHub Releases 下载最新版本
- 自动安装到合适的目录

### ✅ 5. 文档

- **INSTALL.md**: 详细的安装指南
- **PUBLISHING.md**: 发布流程说明
- **RELEASE_CHECKLIST.md**: 发布检查清单
- **README.md**: 更新了安装说明

## 下一步操作

### 步骤 1：创建 GitHub 仓库

```bash
# 如果还没有推送到 GitHub
git remote add origin https://github.com/fagao-ai/cte.git
git branch -M main
git push -u origin main
```

### 步骤 2：创建 Homebrew Tap 仓库

```bash
# 创建一个新的 GitHub 仓库：homebrew-tap
git clone https://github.com/fagao-ai/homebrew-tap.git
cd homebrew-tap
mkdir -p Formula

# 从 cte 项目复制 Formula 文件
cp /path/to/cte/cte.rb Formula/

git add .
git commit -m "Add cte formula"
git push origin main
```

### 步骤 3：配置 GitHub Secrets

在 cte 仓库中设置 Secret：

1. 访问：https://github.com/fagao-ai/cte/settings/secrets/actions
2. 点击 "New repository secret"
3. 添加：
   - Name: `HOMEBREW_TAP_TOKEN`
   - Value: 你的 Personal Access Token (需要 repo 权限)

### 步骤 4：首次发布

```bash
# 确保在 main 分支
git checkout main

# 更新版本号（如果需要）
vim Cargo.toml

# 创建第一个 release tag
git add .
git commit -m "Release v0.1.0"

git tag -a v0.1.0 -m "First release of cte"
git push origin main
git push origin v0.1.0
```

### 步骤 5：验证

等待 GitHub Actions 完成后（约 5-10 分钟）：

```bash
# 测试 Homebrew 安装
brew tap fagao-ai/tap
brew install cte
cte --version

# 测试安装脚本
curl -fsSL https://raw.githubusercontent.com/fagao-ai/cte/main/scripts/install.sh | sudo sh
cte --version
```

## 用户安装方式

完成上述步骤后，用户可以通过以下方式安装：

### macOS 用户

```bash
# 方式 1: Homebrew（推荐）
brew tap fagao-ai/tap
brew install cte

# 方式 2: 安装脚本
curl -fsSL https://raw.githubusercontent.com/fagao-ai/cte/main/scripts/install.sh | sudo sh

# 方式 3: 手动下载
curl -L https://github.com/fagao-ai/cte/releases/latest/download/cte-darwin-amd64.tar.gz | tar xz
sudo mv cte /usr/local/bin/
```

### Linux 用户

```bash
# 方式 1: 安装脚本（推荐）
curl -fsSL https://raw.githubusercontent.com/fagao-ai/cte/main/scripts/install.sh | sudo sh

# 方式 2: 从源码编译
cargo install cte

# 方式 3: 手动下载
wget https://github.com/fagao-ai/cte/releases/latest/download/cte-linux-amd64.tar.gz
tar xzf cte-linux-amd64.tar.gz
sudo mv cte /usr/local/bin/
```

### Windows 用户

```powershell
# 方式 1: PowerShell 安装脚本（推荐）
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/fagao-ai/cte/main/scripts/install.ps1" -OutFile "install.ps1"
.\install.ps1

# 方式 2: Scoop
scoop bucket add fagao-ai https://github.com/fagao-ai/scoop-bucket
scoop install cte

# 方式 3: 手动下载
# 从 https://github.com/fagao-ai/cte/releases 下载 cte-windows-amd64.zip
# 解压后将 cte.exe 添加到 PATH
```

### Ubuntu/Debian 用户

```bash
# APT 仓库（需要额外设置，见 PUBLISHING.md）
wget -qO- https://fagao-ai.github.io/cte/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/cte.gpg
echo "deb [arch=$(dpkg --print-architecture)] https://fagao-ai.github.io/cte/apt stable main" | sudo tee /etc/apt/sources.list.d/cte.list
sudo apt update
sudo apt install cte
```

## 注意事项

1. **Homebrew Tap 需要单独创建**：这是另一个 GitHub 仓库，名称必须是 `homebrew-tap` 或 `homebrew-tap`

2. **APT 仓库需要 GPG 密钥**：如果要使用 APT 仓库，需要生成 GPG 密钥用于签名包

3. **GitHub Actions 权限**：确保仓库设置中启用了 Actions，并有足够的权限

4. **测试所有安装方式**：每次发布后，测试所有安装方式确保正常工作

## 快速测试

在本地测试安装脚本：

```bash
# 测试但不实际安装（dry run）
bash -x scripts/install.sh

# 实际安装到临时目录
sudo DEST_DIR=/tmp/test-install bash scripts/install.sh
```

## 相关链接

- [Homebrew 官方文档](https://docs.brew.sh/)
- [Debian 打包指南](https://www.debian.org/doc/manuals/debmake-doc/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Semantic Versioning](https://semver.org/)
