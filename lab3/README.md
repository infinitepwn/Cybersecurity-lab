# Lab 3 实验报告模板

本目录提供第三次实验报告的空白 LaTeX 框架。实验正文尚未填写；按章节分别维护内容，图片放在 `figures/`。

## 编译

在本目录执行：

```sh
make
```

生成文件位于 `dist/report.pdf`，LaTeX 中间文件位于 `build/`。

```sh
make clean       # 删除中间文件
make distclean   # 同时删除生成的 PDF
```

## 文件结构

- `report.tex`：封面、章节顺序和公共设置。
- `content/1lab_target.tex`、`content/2lab_principle.tex`：实验目标和实验原理。
- `content/task1.tex` 至 `content/task4.tex`：四个实验的独立章节。
- `content/discussion.tex`：实验讨论。
- `content/append/key-code.tex`：附录代码。
- `references.bib`：参考资料条目。
- `lab1report.cls`：沿用仓库现有报告版式。
