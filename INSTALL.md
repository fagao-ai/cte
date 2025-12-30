# 安装指南

## 方式一：从 GitHub Releases 下载（推荐）

### macOS

```bash
# Intel Mac
curl -L https://github.com/fagao-ai/cte/releases/latest/download/cte-darwin-amd64 -o cte
sudo mv cte /usr/local/bin/

# Apple Silicon (M1/M2)
curl -L https://github.com/fagao-ai/cte/releases/latest/download/cte-darwin-arm64 -o cte
sudo mv cte /usr/local/bin/
```

### Linux

```bash
# AMD64
curl -L https://github.com/fagao-ai/cte/releases/latest/download/cte-linux-amd64 -o cte
sudo mv cte /usr/local/bin/
```

### Windows

```powershell
# 下载二进制文件
Invoke-WebRequest -Uri "https://github.com/fagao-ai/cte/releases/latest/download/cte-windows-amd64.exe" -OutFile "cte.exe"
# 将 cte.exe 添加到 PATH 或移动到系统路径
```

### 验证安装

```bash
cte --version
cte --help
```

## 方式二：使用安装脚本

### Linux/macOS

```bash
curl -fsSL https://raw.githubusercontent.com/fagao-ai/cte/main/scripts/install.sh | sudo sh
```

### Windows

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/fagao-ai/cte/main/scripts/install.ps1" -OutFile "install.ps1"
.\install.ps1
```

## 方式三：从源码构建

如果你已经安装了 Rust：

```bash
cargo install cte
```

或从源码构建：

```bash
git clone https://github.com/fagao-ai/cte.git
cd cte
cargo build --release

# Linux/macOS
sudo cp target/release/cte /usr/local/bin/

# Windows - 将 target/release/cte.exe 添加到 PATH
```

## 卸载

### Linux/macOS

```bash
sudo rm /usr/local/bin/cte
```

### Windows

删除 cte.exe 文件，并从 PATH 中移除。

## 系统要求

- **最低**: Linux glibc 2.17+ 或 macOS 10.12+ 或 Windows 10+
- **推荐**: Linux glibc 2.27+ 或 macOS 11+ 或 Windows 11+
- **架构**: amd64 (x86_64) 或 arm64 (aarch64)

## 故障排除

### Linux/macOS

**权限问题:**
```bash
chmod +x /usr/local/bin/cte
```

**PATH 问题:**
```bash
# 检查是否在 PATH 中
which cte

# 如果不在，添加到 PATH
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Windows

**PATH 设置:**
```powershell
# 查看当前 PATH
$env:Path -split ';'

# 添加到用户 PATH（永久）
[Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'User') + ';C:\Path\To\Cte', 'User')
```

**执行策略:**
```powershell
# 如果无法运行脚本
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 开发者指南

### 发布新版本

1. 更新 `Cargo.toml` 中的版本号
2. 创建并推送 tag：

```bash
git tag -a v0.x.x -m "Release v0.x.x"
git push origin v0.x.x
```

3. GitHub Actions 会自动：
   - ✅ 构建多平台二进制文件（Linux/macOS/Windows）
   - ✅ 创建 GitHub Release

### 从源码构建

```bash
# 克隆仓库
git clone https://github.com/fagao-ai/cte.git
cd cte

# 构建
cargo build --release

# 运行测试
cargo test

# 安装
sudo cp target/release/cte /usr/local/bin/  # Linux/macOS
# 或将 target/release/cte.exe 添加到 PATH  # Windows
```
