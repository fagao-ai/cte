# Config to ENV (cte)

一个灵活的配置文件转环境变量语句的运维工具，支持多种配置格式，具有良好的可扩展性。

## 特性

- ✅ 支持多种配置格式：YAML、TOML、JSON
- ✅ 跨平台支持：Windows、macOS、Linux
- ✅ 基于 Trait 的可扩展架构，轻松添加新的配置格式
- ✅ 支持环境变量前缀
- ✅ 自定义分隔符（默认 `_`）
- ✅ 可选择是否转为大写（默认转为大写）
- ✅ 递归处理嵌套配置
- ✅ 支持数组索引

## 安装

### macOS/Linux (推荐)

**使用 Homebrew:**
```bash
brew tap fagao-ai/tap
brew install cte
```

**使用 APT (Debian/Ubuntu):**
```bash
# 添加仓库
wget -qO- https://fagao-ai.github.io/cte/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/cte.gpg
echo "deb [arch=$(dpkg --print-architecture)] https://fagao-ai.github.io/cte/apt stable main" | sudo tee /etc/apt/sources.list.d/cte.list

# 安装
sudo apt update
sudo apt install cte
```

**使用安装脚本:**
```bash
curl -fsSL https://raw.githubusercontent.com/fagao-ai/cte/main/scripts/install.sh | sudo sh
```

### Windows

**PowerShell:**
```powershell
# 使用安装脚本
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/fagao-ai/cte/main/scripts/install.ps1" -OutFile "install.ps1"
.\install.ps1
```

**或使用 Scoop:**
```powershell
scoop bucket add fagao-ai https://github.com/fagao-ai/scoop-bucket
scoop install cte
```

### 从源码构建

```bash
# 安装 Rust (如果还没安装)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 克隆并构建
git clone https://github.com/fagao-ai/cte.git
cd cte
cargo build --release
sudo cp target/release/cte /usr/local/bin/
```

### 预编译二进制

从 [GitHub Releases](https://github.com/fagao-ai/cte/releases) 下载适合你系统的二进制文件。

更多安装方式请查看 [完整安装指南](INSTALL.md)。

## 使用方法

### 基本用法

```bash
# 转换 YAML 配置文件
cte -i config.yaml

# 转换 TOML 配置文件
cte -i config.toml

# 添加前缀（注意：前缀不会自动添加分隔符，请在前缀中包含）
cte -i config.yaml --prefix APP_

# 使用自定义分隔符
cte -i config.yaml --separator "__"

# 保持小写（默认转为大写）
cte -i config.yaml --no-uppercase

# 输出到文件
cte -i config.yaml -o .env

# 完整示例
cte -i config.yaml --prefix APP_ --separator "__" -o .env
```

### 命令行选项

- `-i, --input <INPUT>`: 配置文件路径（必需）
- `-o, --output <OUTPUT>`: 输出文件路径（可选，默认输出到 stdout）
- `-f, --format <FORMAT>`: 配置文件类型（可选，自动根据扩展名检测）
- `-p, --prefix <PREFIX>`: 环境变量前缀
- `-s, --separator <SEPARATOR>`: 分隔符，用于替换嵌套键中的点号（默认 `_`）
- `--no-uppercase`: 保持键的小写（默认转为大写）
- `-h, --help`: 显示帮助信息
- `-V, --version`: 显示版本信息

## 示例

### YAML 示例

**输入 (config.yaml):**
```yaml
database:
  host: "localhost"
  port: 5432
  credentials:
    username: "admin"
    password: "secret"
```

**命令:**
```bash
cte -i config.yaml --prefix DB_
```

**输出:**
```bash
DB_DATABASE_HOST=localhost
DB_DATABASE_PORT=5432
DB_DATABASE_CREDENTIALS_USERNAME=admin
DB_DATABASE_CREDENTIALS_PASSWORD=secret
```

### TOML 示例

**输入 (config.toml):**
```toml
[server]
host = "0.0.0.0"
port = 8080

[server.database]
name = "mydb"
pool_size = 10
```

**命令:**
```bash
cte -i config.toml --prefix APP_ --separator "__"
```

**输出:**
```bash
APP_SERVER__HOST=0.0.0.0
APP_SERVER__PORT=8080
APP_SERVER__DATABASE__NAME=mydb
APP_SERVER__DATABASE__POOL_SIZE=10
```

### 数组支持

**输入:**
```yaml
servers:
  - host: "server1.example.com"
    port: 8001
  - host: "server2.example.com"
    port: 8002
```

**输出:**
```bash
SERVERS_0_HOST=server1.example.com
SERVERS_0_PORT=8001
SERVERS_1_HOST=server2.example.com
SERVERS_1_PORT=8002
```

## 扩展性

### 添加新的配置格式

该工具使用 Trait 体系实现良好的扩展性。要添加新的配置格式，只需：

1. 实现 `ConfigParser` trait
2. 在 `main.rs` 中注册新的解析器

**示例：添加 JSON 支持**

```rust
// 在 src/json_parser.rs 中
use crate::parser::ConfigParser;
use anyhow::{Context, Result};
use std::collections::HashMap;
use serde_json::Value;

pub struct JsonParser;

impl JsonParser {
    pub fn new() -> Self {
        Self
    }
}

impl Default for JsonParser {
    fn default() -> Self {
        Self::new()
    }
}

impl ConfigParser for JsonParser {
    fn parse(&self, content: &str) -> Result<HashMap<String, String>> {
        let json_value: Value =
            serde_json::from_str(content).context("Failed to parse JSON content")?;

        let mut result = HashMap::new();
        self.flatten_value("", &json_value, &mut result);

        Ok(result)
    }

    fn name(&self) -> &str {
        "json"
    }
}

impl JsonParser {
    fn flatten_value(&self, prefix: &str, value: &Value, result: &mut HashMap<String, String>) {
        // 实现类似于 YAML/TOML 解析器的扁平化逻辑
        // ...
    }
}
```

然后在 `main.rs` 中添加：

```rust
mod json_parser;  // 添加模块声明

use json_parser::JsonParser;  // 导入

// 在 main 函数中注册
let parser: Box<dyn ConfigParser> = match format.as_str() {
    "yaml" | "yml" => Box::new(YamlParser::new()),
    "toml" => Box::new(TomlParser::new()),
    "json" => Box::new(JsonParser::new()),  // 添加 JSON 支持
    _ => bail!("Unsupported format: {}", format),
};
```

### 核心 Trait

```rust
pub trait ConfigParser: Send + Sync {
    /// 解析配置字符串，返回通用的键值对映射
    fn parse(&self, content: &str) -> Result<HashMap<String, String>>;

    /// 返回解析器的名称
    fn name(&self) -> &str;
}
```

## 项目结构

```
cte/
├── src/
│   ├── main.rs          # CLI 入口和主程序逻辑
│   ├── parser.rs        # 核心 Trait 和 ENV 生成器
│   ├── yaml_parser.rs   # YAML 解析器实现
│   └── toml_parser.rs   # TOML 解析器实现
├── examples/
│   ├── config.yaml      # YAML 示例配置
│   └── config.toml      # TOML 示例配置
├── Cargo.toml
└── README.md
```

## 测试

运行测试：

```bash
cargo test
```

运行示例：

```bash
# YAML 示例
./target/debug/cte -i examples/config.yaml --prefix APP

# TOML 示例
./target/debug/cte -i examples/config.toml --prefix APP
```

## 依赖

- `serde`: 序列化/反序列化框架
- `serde_yaml`: YAML 支持
- `toml`: TOML 支持
- `clap`: 命令行参数解析
- `anyhow`: 错误处理

## License

MIT
