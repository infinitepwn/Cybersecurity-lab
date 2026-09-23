\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lab1report}[2026/09/10 LaTeX class for the cybersecurity laboratory report]

% Forward optional ctexart options, for example fontset=fandol on Linux/Overleaf.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexart}}
\ProcessOptions\relax
\LoadClass[a4paper,12pt]{ctexart}

\RequirePackage{geometry}
\geometry{a4paper,left=2.5cm,right=2.5cm,top=2.5cm,bottom=2.5cm}
\RequirePackage{fontspec}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{array}
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{longtable}
\RequirePackage{caption}
\RequirePackage{titlesec}
\RequirePackage{fancyhdr}
\RequirePackage{enumitem}
\RequirePackage{listings}
\RequirePackage{xparse}
\RequirePackage{etoolbox}
\RequirePackage{footmisc}
\RequirePackage[backend=biber,style=numeric,sorting=none]{biblatex}
\RequirePackage{hyperref}

% ctex maps these logical Chinese fonts to SimSun/SimHei on Windows.
\AtBeginDocument{%
  \songti
  \zihao{-4}% 小四
  \setlength{\parindent}{2em}% 首行缩进 2 个汉字
  \setlength{\parskip}{0pt}% 段前段后 0
  \setlength{\baselineskip}{20pt}% 固定值 20 磅
}

% 一级标题三号、二级标题小三号、三级标题四号；段前段后 0.5 行。
\titleformat{\section}{\heiti\zihao{3}}{\thesection}{0.75em}{}
\titleformat{\subsection}{\heiti\zihao{-3}}{\thesubsection}{0.75em}{}
\titleformat{\subsubsection}{\heiti\zihao{4}}{\thesubsubsection}{0.75em}{}
\titlespacing*{\section}{0pt}{10pt}{10pt}
\titlespacing*{\subsection}{0pt}{10pt}{10pt}
\titlespacing*{\subsubsection}{0pt}{10pt}{10pt}

% 页码底部居中，无页眉横线。
\pagestyle{fancy}
\fancyhf{}
\fancyfoot[C]{\songti\zihao{5}\thepage}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancypagestyle{plain}{%
  \fancyhf{}
  \fancyfoot[C]{\songti\zihao{5}\thepage}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}

\hypersetup{hidelinks,unicode=true}
\urlstyle{same}
\captionsetup{font={small},labelsep=space}

% 代码：等宽字体、行号、自动换行，适合命令和终端输出。
\lstset{%
  basicstyle=\ttfamily\small,
  keywordstyle=\color{blue!70!black}\bfseries,
  commentstyle=\color{gray!70!black}\itshape,
  stringstyle=\color{teal!70!black},
  identifierstyle=\color{black},
  numbers=left,
  numberstyle=\tiny\color{gray},
  numbersep=8pt,
  frame=single,
  framerule=0.3pt,
  rulecolor=\color{gray!55},
  breaklines=true,
  breakatwhitespace=false,
  showstringspaces=false,
  columns=fullflexible,
  keepspaces=true,
  xleftmargin=2em,
  framexleftmargin=1.5em
}
\lstdefinelanguage{yaml}{
  morekeywords={
    true,false,null,
    services,networks,image,build,
    container_name,hostname,privileged,
    restart,cap_add,interface_name,
    ipv4_address,subnet,gateway
  },
  keywordstyle=\color{blue}\bfseries,
  comment=[l]{\#},
  commentstyle=\color{gray}\itshape,
  morestring=[b]',
  morestring=[b]",
  stringstyle=\color{teal}
}

% 直接引用的脚注标记使用 ①②③ 等圆圈数字；使用 TeX 圆圈排版，避免
% 不同系统中文字体对 U+2460 等字符支持不一致。
\makeatletter
\newcommand{\lab@circled}[1]{%
  \textcircled{\scriptsize\ifcase#1\relax 0\or1\or2\or3\or4\or5\or6\or7\or8\or9\or10\else\number#1\fi}%
}
\renewcommand{\thefootnote}{\lab@circled{\value{footnote}}}
\makeatother

% 直接引用：\labquote[页码]{bib-key}
\NewDocumentCommand{\labquote}{O{}m}{%
  \footnote{\fullcite{#2}\ifblank{#1}{}{，第 #1 页。}}%
}

% 图片辅助命令：\labfigure[宽度]{文件}{标题}{标签}
\NewDocumentCommand{\labfigure}{O{0.86\linewidth} m m m}{%
  \begin{figure}[H]
    \centering
    \includegraphics[width=#1]{#2}
    \caption{#3}
    \label{#4}
  \end{figure}
}

% 封面字段。
\makeatletter
\newcommand{\lab@university}{山东大学}
\newcommand{\lab@college}{网络空间安全学院}
\newcommand{\lab@course}{XXXXXXX}
\newcommand{\lab@reporttitle}{实验报告}
\newcommand{\lab@student}{姓名（学号）}
\newcommand{\lab@instructor}{指导教师}
\newcommand{\lab@major}{专业班级}
\newcommand{\lab@date}{\today}
\newcommand{\university}[1]{\gdef\lab@university{#1}}
\newcommand{\college}[1]{\gdef\lab@college{#1}}
\newcommand{\course}[1]{\gdef\lab@course{#1}}
\newcommand{\reporttitle}[1]{\gdef\lab@reporttitle{#1}}
\newcommand{\student}[1]{\gdef\lab@student{#1}}
\newcommand{\instructor}[1]{\gdef\lab@instructor{#1}}
\newcommand{\major}[1]{\gdef\lab@major{#1}}
\newcommand{\completiondate}[1]{\gdef\lab@date{#1}}

\newcommand{\lab@coverline}[2]{%
  % 固定标签列和可伸缩内容列：内容过长时在内容列内自动换行，
  % 同时保证所有内容列从同一位置开始。
  \noindent\hspace*{2em}%
  \begin{tabularx}{0.90\textwidth}{@{}>{\raggedright\arraybackslash}p{0.22\textwidth}@{\hspace{1em}}>{\raggedright\arraybackslash}X@{}}
    #1 & #2\\[-0.2ex]
    \cline{2-2}
  \end{tabularx}\par
}

\newcommand{\makecover}{%
  \begin{titlepage}
    \thispagestyle{empty}
    \centering
    \vspace*{1.6cm}
    {\heiti\fontsize{36pt}{48pt}\selectfont \lab@university\par}
    {\heiti\fontsize{36pt}{48pt}\selectfont \lab@college\par}
    \vfill
    {\heiti\fontsize{36pt}{48pt}\selectfont 《\lab@course》\par}
    {\heiti\fontsize{36pt}{48pt}\selectfont \lab@reporttitle\par}
    \vfill
    \begin{flushleft}
      {\heiti\fontsize{15pt}{28pt}\selectfont
        \lab@coverline{学生姓名}{\lab@student}
        \lab@coverline{指导教师}{\lab@instructor}
        \lab@coverline{学    院}{\lab@college}
        \lab@coverline{专业班级}{\lab@major}
        \lab@coverline{完成时间}{\lab@date}
      }
    \end{flushleft}
  \end{titlepage}
  \setcounter{page}{1}
}
\makeatother

\newcommand{\todo}[1]{\textcolor{red}{[待填写：#1]}}

% 参考资料标题遵循一级标题格式，并加入目录（若启用目录）。
\defbibheading{labbibliography}[参考资料]{%
  \section*{#1}
  \addcontentsline{toc}{section}{#1}
}

\endinput
