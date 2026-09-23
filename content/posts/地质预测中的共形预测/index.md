---
title: "【方法论】地质预测中的共形预测：从一个数到有校准依据的区间"
date: 2026-09-23T10:00:00+08:00
draft: false
math: true
isCJKLanguage: true
description: "以 TOC 回归为例解释共形预测的有限样本校准、预测区间与覆盖率，梳理跨井验证、分布偏移及 2026 年重要研究。"
summary: "预测 TOC 为 2.30%，误差范围应该如何给出？共形预测可以在现有回归模型之后增加校准步骤。本文给出完整数值示例，区分边际覆盖与单井可靠性，并讨论等宽区间、分位数回归、跨井分布偏移和小样本条件下的使用边界。"
tags: ["方法论", "共形预测", "不确定性量化", "机器学习", "测井解释", "跨井验证"]
categories: ["方法论"]
---

一个模型给出 TOC 为 2.30%，这个数值本身没有说明预测误差可能有多大。对于需要决定是否补充取样、复测或复核的地质工作，预测区间往往比单一数值更有用。

**共形预测（conformal prediction，CP）可以在已经训练好的模型之后，利用单独保留的数据校准预测集合或区间。** 它不要求先把随机森林、支持向量机或神经网络替换成另一种算法。真正需要重新安排的，是数据划分、误差校准和验证方式。

> 本文以连续变量回归为主。TOC 数值和残差均为教学示例，不是实际井资料或已完成的模型结果。文献中的理论保证有明确条件，尤其不能直接套用到具有深度相关性和跨井差异的全部测井行数据上。

## 1. “90% 覆盖”到底是什么意思

设输入为 $X$，观测目标为 $Y$，输出区间为 $C(X)$，允许的失覆盖率为 $\alpha$。共形预测最常见的目标是：

<div class="math-display">
$$
\Pr\{Y_{\mathrm{new}}\in C(X_{\mathrm{new}})\}\ge 1-\alpha.
$$
</div>

令 $\alpha=0.10$，目标便是至少 90% 的**边际覆盖率**。在基本分割式 CP 中，这要求校准样本与未来样本具有适当的可交换性，且模型和评分规则没有使用校准标签来训练或挑选。独立同分布是满足可交换性的一个常见充分条件。

这一概率对校准数据和未来样本的随机性取平均，并不是在承诺每次有限测试集恰好覆盖 90%。它也不表示“对这个固定井段，真实 TOC 有 90% 的后验概率落在区间里”。预测区间针对未来观测，不能与回归均值的置信区间混称。基础定义可参阅 [Angelopoulos 与 Bates 的入门教程](https://arxiv.org/abs/2107.07511)。

| 容易混淆的表述 | 应当怎样理解 |
|---|---|
| 总体覆盖率达到 90% | 不保证每口井、每种岩性、每个 TOC 范围都达到 90% |
| 单个深度点具有覆盖保证 | 不等于整条井曲线上的所有点同时被覆盖 |
| 不要求指定误差服从正态分布 | 仍然需要满足所用方法的数据假设 |
| 区间经过校准 | 不代表区间足够窄，也不代表点预测准确 |

地质应用中应先写清楚：最终要覆盖的是**一个新样品、随机新井中的某个样品，还是整口井的一组目标值**。不同目标需要不同的校准设计。

## 2. 分割式共形预测：三组数据、三个职责

最容易审计的起点是 split conformal prediction：

| 数据部分 | 可以做什么 | 必须保留的边界 |
|---|---|---|
| 训练侧 | 拟合预处理、选择变量、调参、训练模型 | 调参使用训练侧内部验证 |
| 校准集 | 在模型固定后计算评分，确定区间修正量 | 不再用于选择表现最好的模型或特征 |
| 最终测试集 | 检查覆盖率、宽度和点预测误差 | 不参与阈值、模型或区间方案的选择 |

训练得到 $\hat f$ 后，在 $n$ 个校准样本上计算绝对残差：

<div class="math-display">
$$
s_i=\left|y_i-\hat f(x_i)\right|,\qquad i=1,\ldots,n.
$$
</div>

将残差从小到大排序，取带有限样本修正的次序统计量：

<div class="math-display">
$$
k=\left\lceil(n+1)(1-\alpha)\right\rceil,\qquad
\hat q=s_{(k)}.
$$
</div>

若 $k=n+1$，采用 $\hat q=+\infty$ 的约定。新样本的区间为：

<div class="math-display">
$$
C(x)=\left[\hat f(x)-\hat q,\;\hat f(x)+\hat q\right].
$$
</div>

其中 $s_{(k)}$ 表示第 $k$ 小的校准评分，$\hat q$ 与预测目标具有相同单位。应直接核对次序统计量，不能随意换成带线性插值的普通百分位数。分割式回归推断的理论与扩展见 [Lei 等（2018）](https://doi.org/10.1080/01621459.2017.1307116)及[作者公开全文](https://www.stat.cmu.edu/~ryantibs/papers/conformal-jasa.pdf)。

### 2.1 一个可以手算的 TOC 示例

假设 TOC 以百分数的数值形式存储：`2.30` 表示 2.30%，而不是存为 `0.023`。现有 20 个校准残差，目标覆盖率为 90%，则

<div class="math-display">
$$
k=\lceil21\times0.90\rceil=19.
$$
</div>

若第 19 小的残差为 0.42 个百分点，而新样品预测值为 2.30%，区间为：

<div class="math-display">
$$
[2.30-0.42,\;2.30+0.42]\%=[1.88\%,\;2.72\%].
$$
</div>

这里的误差是 **0.42 个百分点**，不是相对误差 0.42%。如果将 TOC 改为小数存储，残差和区间端点也必须按同一比例转换。

下面的 Python 示例只演示校准量计算，不包含模型训练，也不检验可交换性：

```python {style="monokai"}
from fractions import Fraction
from math import ceil, inf, isfinite

def split_cp_radius(residuals, alpha=0.10):
    scores = sorted(abs(float(v)) for v in residuals)
    if not 0 < alpha < 1 or not scores:
        raise ValueError("需要非空残差以及 0 < alpha < 1")
    if not all(isfinite(v) for v in scores):
        raise ValueError("残差必须是有限数值")
    # 按输入的小数计算阶次，避免浮点舍入使整数边界多取一位。
    rank = ceil((len(scores) + 1) * (1 - Fraction(str(alpha))))
    return scores[rank - 1] if rank <= len(scores) else inf

# 人工构造的 20 个残差，单位为 TOC 百分点。
residuals = [0.03, 0.05, 0.06, 0.08, 0.10, 0.11, 0.12, 0.14,
             0.16, 0.18, 0.19, 0.20, 0.22, 0.24, 0.27, 0.29,
             0.32, 0.36, 0.42, 0.70]
q = split_cp_radius(residuals)
prediction = 2.30
print(f"q = {q:.2f}")
print(f"区间 = [{prediction - q:.2f}%, {prediction + q:.2f}%]")
```

输出为 `q = 0.42` 和 `区间 = [1.88%, 2.72%]`。若只有 8 个校准样本，90% 目标对应第 9 个次序位置，以上规则将返回无限宽区间。此时不能把最大残差直接顶替进去，并继续宣称拥有同样的保证。

### 2.2 模型不准时，校准也不会创造信息

若模型的误差很大，校准结果可以是一个很宽的区间。它可能满足覆盖目标，却无法支持实际决策。因而，点预测误差与区间质量需要同时评价；不能用“覆盖率达标”掩盖一个缺乏预测能力的模型。

## 3. 为什么最基础的 CP 不能给样品排风险顺序

在绝对残差版本中，同一校准集得到的 $\hat q$ 对所有新样品相同，每个区间的宽度都是 $2\hat q$。因此，不能用这种等宽区间把井段分成“高不确定性”和“低不确定性”。

如果希望宽度随输入变化，可以在训练侧学习局部误差尺度，或使用共形化分位数回归。无论哪种做法，**宽度的变化都来自额外模型或评分设计**，不是 CP 自动识别出所有外推风险。

### 3.1 共形化分位数回归：保留异方差信息

Conformalized Quantile Regression（CQR）先在训练侧拟合下、上分位数函数 $\hat Q_L(x)$、$\hat Q_U(x)$，再在校准集计算：

<div class="math-display">
$$
s_i=\max\left\{\hat Q_L(x_i)-y_i,\;y_i-\hat Q_U(x_i)\right\}.
$$
</div>

用同样的有限样本次序规则求出 $\hat q$，得到

<div class="math-display">
$$
C(x)=\left[\hat Q_L(x)-\hat q,\;\hat Q_U(x)+\hat q\right].
$$
</div>

这里 $\hat q$ 仍是统一修正量，但初始上下分位数之间的距离可以随样品变化。这个评分允许负值，不能照搬前一段对残差取绝对值的代码。方法来源是 [Romano、Patterson 与 Candès（NeurIPS 2019）](https://proceedings.neurips.cc/paper/2019/hash/5103c3584b063c431bd1268e9b5e76fb-Abstract.html)。

CQR 的自适应宽度并不自动提供逐个输入条件下的覆盖保证，也不能确保一个训练范围之外的样品必然得到宽区间。外推识别还需要独立检查特征支持范围和地质适用范围。

## 4. 地质资料最关键的难点：可交换单位是什么

### 4.1 相邻测井行不能当作大量独立证据

连续井段具有深度相关性。随机拆分行数据，会让相邻层段同时进入训练、校准和测试，导致模型与校准误差都显得过于理想。

本文建议按目标场景安排分组：预测未见井时，以井划分训练、校准和测试；研究井内未观测段时，使用具有地质依据的深度块和隔离带，并明确这种评价并不等于跨井能力。

但是，**按井拆分只能减少泄漏，不能自动证明所有校准行与新井数据可交换**。如果希望对整口新井给出正式的同时覆盖保证，需要将井视为单位，设计与目标一致的组级评分，例如每口校准井在预先定义位置集合上的最大残差，并采用相应理论。此时有效校准单位是井，不能把数千个深度点当作数千个独立校准样本；还需要校准井和目标井本身具有适当的可交换性。

这段是针对地质资料的实验设计建议。若现有井数不足以支持上述设计，应如实报告经验覆盖率，而不要把标准独立样本定理直接移植过来。

### 4.2 跨区迁移可能改变什么

协变量偏移（covariate shift）通常指输入分布变化，而给定输入后的目标分布保持不变：

<div class="math-display">
$$
P_{\mathrm{target}}(X)\ne P_{\mathrm{source}}(X),\qquad
P_{\mathrm{target}}(Y\mid X)=P_{\mathrm{source}}(Y\mid X).
$$
</div>

例如，目标井的某些测井响应组合出现得更多，可能接近这一设定。但若不同成岩背景使“同样曲线对应的 TOC 或渗透率”发生变化，第二个等式就未必成立。

[Tibshirani 等（2019）](https://arxiv.org/abs/1904.06019)研究了协变量偏移下的加权共形预测。其启发是校准权重需要反映目标分布；它不是对任意地质域变化的通用修复。支持范围重叠不足、密度比估计误差或条件分布改变，都需要单独处理。

## 5. 2026 年的重要进展，怎样读才有用

| 论文 | 核心用途 | 阅读时需要保留的边界 |
|---|---|---|
| [Gopakumar 等：代理模型的 CP 不确定性量化](https://doi.org/10.1088/2632-2153/ae2e7b) | 展示如何为不同科学计算代理模型增加校准层 | 训练模型与目标场景不同，不代表可忽略校准数据的代表性；输出点覆盖也需与整体覆盖区分 |
| [Laghuvarapu 等：KMM-CP](https://proceedings.mlr.press/v337/laghuvarapu26a.html) | 利用核均值匹配处理协变量偏移，并选择支持重叠较可靠的区域 | 论文给出相应条件下的渐近保证；限定区域后的结果不能代表整个目标域 |
| [Min、Peng 与 Zou：利用不完美辅助信息的局部化 CP](https://doi.org/10.1080/01621459.2026.2687844) | 研究辅助数据如何改善局部适应性 | 不能简化成“附近找几个残差再取百分位数”就拥有同样保证 |
| [Li、Zheng 与 Lin：协变量偏移下的生成式 CP](https://doi.org/10.1080/10618600.2026.2703276) | 将条件生成模型与偏移校准结合 | 生成器、权重估计和分布假设仍影响实际效果 |
| [Koeshidayatullah 等：跨盆地测井补全与异常检测](https://doi.org/10.1016/j.engeos.2026.100536) | 提供时序基础模型结合 CP 区间的地学应用案例 | 论文发表于 **Energy Geoscience**；补全和异常检测结果不能直接证明 TOC 或渗透率回归同样有效 |

这些文献提供了方法选择，而不是要求小样本项目立即叠加复杂模型。对于已有随机森林或其他回归模型的工作，先把基本划分和校准做好，通常更容易定位问题。

## 6. 一份可以执行的最小实验清单

以下方案以“新井 TOC 预测”为例，是本文提出的验证流程。

1. **锁定预测目标与观测口径。** 明确样品代表的深度范围、测井与实验的匹配规则、检测方法及单位。校准标签应来自符合目标定义的实际观测，不能用模型插补或伪标签充当真值。
2. **先固定井级划分。** 在查看最终测试结果之前确定训练井、校准井、测试井，并检查岩性和特征范围。缺失值处理、标准化、变量筛选和调参均在训练侧完成。
3. **从一个点预测基线开始。** 固定模型，再根据明确的采样单位校准 CP。若井内相关性尚未被方法处理，先将结果定位为经验验证。
4. **再比较一种自适应区间。** 如 CQR；其选择和超参数仍在训练侧确定。避免反复查看同一校准集后选择最窄的方案。
5. **对最终测试井一次性报告完整结果。** 同时呈现点预测误差、覆盖率、区间宽度、失覆盖样品的位置及地质分组表现。

基础统计量可以写为：

<div class="math-display">
$$
\widehat{\mathrm{Coverage}}=
\frac{1}{m}\sum_{j=1}^{m}\mathbf{1}\{L_j\le y_j\le U_j\},
\qquad
\overline W=\frac{1}{m}\sum_{j=1}^{m}(U_j-L_j).
$$
</div>

其中 $m$ 为测试观测数，$L_j,U_j$ 为区间端点。建议同时报告宽度中位数与上分位数，避免少数极宽区间被平均值掩盖；逐井表中应给出观测数，不能只给百分比。不同井点数相差很大时，按点汇总与每井等权汇总应分别注明。

若目标改为渗透率，可考虑在 $\log_{10}K$ 尺度训练和校准，再将端点按 $10^z$ 转回原单位。严格单调变换保持区间包含关系，但必须明确是在对数尺度上校准，不能把对数误差当作原单位的对称误差。

最终是否值得使用 CP，应回到一个具体判断：在独立、符合使用场景的测试资料上，区间是否达到可接受的经验覆盖，宽度是否仍足以支持地质决策，失败是否集中在某些尚未覆盖的地质条件。

## 重要论文链接

1. **Angelopoulos, A. N., & Bates, S.** *A Gentle Introduction to Conformal Prediction and Distribution-Free Uncertainty Quantification*。[arXiv:2107.07511](https://arxiv.org/abs/2107.07511)。入门首选，关注边际覆盖、校准规模与扩展方法。
2. **Lei, J., G’Sell, M., Rinaldo, A., Tibshirani, R. J., & Wasserman, L.（2018）**. *Distribution-Free Predictive Inference for Regression*. **JASA**。[DOI](https://doi.org/10.1080/01621459.2017.1307116)｜[作者全文](https://www.stat.cmu.edu/~ryantibs/papers/conformal-jasa.pdf)。回归共形推断的重要基础论文。
3. **Romano, Y., Patterson, E., & Candès, E. J.（2019）**. *Conformalized Quantile Regression*. **NeurIPS**。[会议原文](https://proceedings.neurips.cc/paper/2019/hash/5103c3584b063c431bd1268e9b5e76fb-Abstract.html)｜[预印本](https://arxiv.org/abs/1905.03222)。
4. **Tibshirani, R. J., Barber, R. F., Candès, E. J., & Ramdas, A.（2019）**. *Conformal Prediction Under Covariate Shift*。[作者预印本](https://arxiv.org/abs/1904.06019)。加权共形预测的重要起点。
5. **Gopakumar, V. 等（2026）**. *Uncertainty quantification of surrogate models using conformal prediction*. **Machine Learning: Science and Technology**, 7, 015025。[DOI](https://doi.org/10.1088/2632-2153/ae2e7b)｜[公开 PDF](https://openreview.net/pdf/e3b989a0935ce6d7d1708f8a96aa3f02accfd890.pdf)。
6. **Laghuvarapu, S., Deb, R., & Sun, J.（2026）**. *KMM-CP: Practical Conformal Prediction under Covariate Shift via Selective Kernel Mean Matching*. **UAI / PMLR**, 337, 3237–3261。[开放论文页面与 PDF](https://proceedings.mlr.press/v337/laghuvarapu26a.html)。
7. **Min, Y., Peng, L., & Zou, C.（2026）**. *Enhanced Localized Conformal Prediction with Imperfect Auxiliary Information*. **JASA**。[DOI](https://doi.org/10.1080/01621459.2026.2687844)。
8. **Li, C., Zheng, S., & Lin, Y.（2026）**. *Generative Conformal Prediction Under Covariate Shift*. **Journal of Computational and Graphical Statistics**。[DOI](https://doi.org/10.1080/10618600.2026.2703276)。
9. **Koeshidayatullah, A., Al-Fakih, A., & Kaka, S. I.（2026）**. *Toward basin-agnostic well log imputation and anomaly detection via a pre-trained time-series foundation model*. **Energy Geoscience**, 7(2), 100536。[DOI](https://doi.org/10.1016/j.engeos.2026.100536)。

*文献与链接核对日期：2026 年 9 月 23 日。*
