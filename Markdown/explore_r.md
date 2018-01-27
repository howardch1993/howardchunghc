# explore r

## 数据结构

1. 向量
2. 属性
3. 矩阵数组
4. 数据框

## 向量

向量有两种形式：原子向量和列表

三种特性：

* 类型，`typeof()` 
* 长度，`length()` 
* 属性，`attributes()` 

判断向量的方法：[原书使用]("https://haoeric.gitbooks.io/r-advanced/content/datastructure.html") `is.atomic(x) || is.list(x)` 来判断一个对象是否为向量。我认为是不对的。还不如用`typeof(x)` 来的直接。

生成向量的一般函数有：`seq(from, to, by, length.out)` ,`rep(x, times, each)`,`c()`



### 原子向量

**4** 常见：logical 逻辑型，integer 整型，double or numeric 数值型，character 字符串型

**2** 不常见：complex 复数型，raw 粗糙型

其他三种`NA`缺失值表示：`NA_real_`,`NA_integer_`,`NA_character_`

#### 强制类型转换

不同类型的通用型由低到高排列是：logical, integer, double, character

###  属性

一个对象的属性可以使用`attr()`来单独产看或修改，也可以使用`attributes()`列出所有属性。

```R
# define obj x
x = rep(c(1,3), each = 3)
# apply attribute to x
attr(x, "my_attr") <- "this is a vector"
# show attribute "my_attr" 
attr(x, "my_attr")
# show structure and attributes of x
str(attributes(x))
```

`structure()`函数可以用来修改一个对象的属性然后返回一个新对象：

```R
structure(1:10, my_attrs = "this is a numeric")
```

当一个向量被修改后，其大部分属性会默认地丢失，但其中有三个最重要的属性是不会丢失的：

* 名字：`names(x)` , 去掉名字`unname(x)`
* 维度：`dim(x)`
* 类：`class(x)`

## 数据框

**可以使用`plyr::rbind.fill()`来合并拥有不同列数的数据框。**

### 特殊列

`I()`函数会给它的输入添加`AsIs`类。使得以下输入成立：

```R
data.frame(x = 1:3, y = I(list(1:2, 1:3, 1:4)))
data.frame(x = 1:3, y = I(matrix(1:9, nrow = 3))) # 只要矩阵行数与数据表相同
```

## 取子集

`setNames(x, letters[1:4])`对向量取名字

```R
# 一些奇奇怪怪的索引
vals <- outer(1:5, 1:5, FUN = "paste", sep = ",")
vals[c(4, 15)]
vals <- outer(1:5, 1:5, FUN = "paste", sep = ",")
select <- matrix(ncol = 2, byrow = TRUE, c(
  1, 1,
  3, 1,
  2, 4
))
vals[select]
```

### S3对象

> S3对象是由原子向量，数组和列表构成的，因此你可以使用上面介绍的方法以及`str()`的帮助来对S3对象取子集。

### S4对象

> 对于S4对象有另外的两种取子集的操作符：`@`(等同于`$`)和`slot()`(等同于`[[`)。`@`相对于`$`更严谨，如果对应所取位置不存在则会报错。这在[面相对象指南](https://haoeric.gitbooks.io/r-advanced/content/qu_zi_ji.html#s4)一章中会详细介绍。

### 简化与保留

如何切换简化或者保留因数据类型的差异而不同。具体的操作概括如下表：

|      | 简化                       | 保留                                       |
| ---- | ------------------------ | ---------------------------------------- |
| 向量   | `x[[1]]`                 | `x[1]`                                   |
| 列表   | `x[[1]]`                 | `x[1]`                                   |
| 因子   | `x[1:4, drop = T]`       | `x[1:4]`                                 |
| 数组   | `x[1, ]` **or** `x[, 1]` | `x[1, , drop = F]` **or** `x[, 1, drop = F]` |
| 数据框  | `x[, 1]` **or** `x[[1]]` | `x[, 1, drop = F]` **or** `x[1]`         |

保留操作对于所有数据类型都是一样的：你得到和输入同样类型的输出。简化操作则对不同的数据类型会有些不同：

- **原向量**：去除名字。

  ```R
  x <- c(a = 1, b = 2)
  x[1]
  x[[1]]
  ```

- **列表**：返回列表中的元素而不是单个元素的列表。

  ```R
  y <- list(a = 1, b = 2)
  str(y[1])
  str(y[[1]])
  ```

- **因子**：去掉多余的水平。

  ```R
  z <- factor(c("a", "b"))
  z[1]
  z[1, drop = TRUE]
  ```

- **矩阵**或**数组**：去掉长度为一的维度。

  ```R
  a <- matrix(1:4, nrow = 2)
  a[1, , drop = FALSE]
  a[1, ]
  ```

- **数据框**：若返回值是单列，则返回一个向量而不是数据框。

  ```R
  df <- data.frame(a = 1:2, b = 1:2)
  str(df[1])
  str(df[[1]])
  str(df[, "a", drop = FALSE])
  str(df[, "a"])
  ```

### 缺失索引与出界索引

下面的表格归纳了在对向量或列表使用`[`和`[[`时，当出现出界索引(OOB)或缺失索引时结果的差异：

| 操作符  | 索引         | 原子向量   | 列表           |
| ---- | ---------- | ------ | ------------ |
| `[`  | OOB        | `NA`   | `list(NULL)` |
| `[`  | `NA_real_` | `NA`   | `list(NULL)` |
| `[`  | `NULL`     | `x[0]` | `list(NULL)` |
| `[[` | OOB        | Error  | Error        |
| `[[` | `NA_real_` | Error  | `NULL`       |
| `[[` | `NULL`     | Error  | Error        |

如果输入向量有名字，那么出界索引(OOB)或缺失索引的名字为`"<NA>"`。

```R
numeric()[1]
numeric()[NA_real_]
numeric()[NULL]
numeric()[[1]]
numeric()[[NA_real_]]
numeric()[[NULL]]

list()[1]
list()[NA_real_]
list()[NULL]
list()[[1]]
list()[[NA_real_]]
list()[[NULL]]
```

## 取子集与任务分派

所有的取子集操作都可以和任务分派结合起来对输入的向量进行选择性地修改。

```R
x <- 1:5
x[c(1, 2)] <- 2:3
x

# LHS的长度必须和RHS一致
x[-1] <- 4:1
x

# 注意：重复的索引不会被除掉，会覆盖前面的赋值
x[c(1, 1)] <- 2:3
x

# 整型索引不能和NA一同使用
x[c(1, NA)] <- c(1, 2)
# 但是NA可以和逻辑索引一同使用 (这时，NA会被视为false)
x[c(T, F, NA)] <- 1
x

# 这对修改向量中修改符合某种条件的元素很有用处
df <- data.frame(a = c(1, 10, NA))
df$a[df$a < 5] <- 0
df$a
```

使用空索引取子集搭配任务分派能保有原对象的类型和结构。比较如下两行代码。第一行中`mtcars`将保持原类型为数据框，而第二行中`mtcars`将成为一个列表。

```R
mtcars[] <- lapply(mtcars, as.integer)
mtcars <- lapply(mtcars, as.integer)
```

对于列表，可以使用取子集＋任务分派＋`NULL`来去除向量中的某个特定元素。如果要添加一个`NULL`到一个列表，则可以使用`[`和`list(NULL)`：

```R
x <- list(a = 1, b = 2)
x[["b"]] <- NULL
str(x)

y <- list(a = 1)
y["b"] <- list(NULL)
str(y)
```

## 实例运用

### 查寻表 (字符串取子集)

```R
x <- c("m", "f", "u", "f", "f", "m", "m")
lookup <- c(m = "Male", f = "Female", u = NA)
lookup[x]
unname(lookup[x])

# 或者更简单的输出
c(m = "Known", f = "Known", u = "Unknown")[x]

# 其实是查X中各个元素的“定义”属性
```

