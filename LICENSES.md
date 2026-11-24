# 许可与署名

本发行版由三部分组成，各自许可独立，互不覆盖。

## 1. 7-Zip 26.06

- 版权：Copyright (C) 1999-2026 Igor Pavlov
- 许可：GNU LGPL v2.1 或更高版本；`7z.dll` 中的部分代码适用 BSD 2/3 条款，RAR 解压代码适用 unRAR 限制
- 全文：`licenses/7-Zip-License.txt`
- 官网：https://www.7-zip.org/
- 源码：https://www.7-zip.org/download.html

7-Zip 是 Igor Pavlov 的商标。本项目的定制版本与其无关，未获官方认可。

## 2. Dark7zip（深色模式）

- 上游：https://github.com/ozone10/7zip-Dark7zip
- 主许可：与 7-Zip 相同（LGPL 及其中的例外条款）
- `DarkMode/` 中的代码来自 darkmodelib，Copyright (c) 2024-2026 ozone10，采用 **MIT 或 MPL-2.0** 双许可
- 许可全文见上游仓库的 `LICENSE.md`

深色配色配置文件 `7zDark.ini` 来自上游项目，按原样保留。

## 3. 文件类型图标（Keka 风格）

- 作者：Zabriskije
- 项目：https://github.com/Zabriskije/macOS-Icons
- 许可：**CC BY-NC-SA 4.0**（署名 - 非商业 - 相同方式共享）
- 全文：http://creativecommons.org/licenses/by-nc-sa/4.0/
- 本发行版中的改动：将项目内 Keka 文档图标的 PNG 转换为 Windows ICO（7 种尺寸），并修正原素材不透明黑底导致的黑边
- 限制：不得用于商业目的；再分发或改编必须以相同协议发布并署名作者

## 4. 本仓库新增的脚本与说明

`scripts/`、`installer/`、`build/` 下由本项目编写的部分，采用 MIT 许可。此许可**不覆盖**上述第 1～3 项的第三方内容。
