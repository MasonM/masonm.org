---
title: "Modeling Mersenne's Clavichord"
date: 2026-05-25
author: Mason Malone
---

For me, one of the most surprising developments in LLMs has been 

# What the hell is a clavichord?

The clavichord is a keyboard instrument that was invented at some point before 1404[^1], and flourished for centuries in Europe until it was replaced by the fortepiano[^2].

My first exposure to the clavichord was last year, when I randomly stumbled on the album [Clavichord Recital by Gustav Leonhardt](https://open.spotify.com/album/7cr4GFB8PtGqEa4KtfUtzO?si=00c4d272c07a4331). I immediately fell in love, and 

## Clavichord Action

A clavichord action is a simple [class 1 lever](https://en.wikipedia.org/wiki/Lever#Types_of_levers), where one end of each key has a piece of metal called a "tangent". When the other end of the key is pressed, the tangent rises and strikes the string. The distance between where the tangent strikes the string and the bridge is called the "sounding length" for that string.

{{< 3d-model src="models/clavichord_action_diagram_compressed.glb" camera-orbit="6.306deg 76.15deg 776.7m" >}}

# Who is Mersenne?

If you're a programmer like me, you've probably heard of "Mersenne primes": prime numbers of the form \(M_n = 2^n -1\). Mersenne primes are named afer Marin Meresenne, a 17th-century French polymath that was active in many areas, and is most well-known for his contributions to mathematics and music[^1]. Mersenne sought to establish a science of music, and his work form the root of modern acoustics[^2]. 

# How Does this Work?

## Clavichord Actions and Mersenne's Laws

 The sounding length, along with the tension and mass per unit length of the string, determines the [fundamental frequency](https://en.wikipedia.org/wiki/Fundamental_frequency) of the key being played. Mersenne was the first to discover and prove the mathematical relationship between these variables, which is now known as [Mersenne's laws](https://en.wikipedia.org/wiki/Mersenne%27s_laws). The usual form of this relationship is given as:
$$
f_0=\frac{1}{2L}\sqrt{\frac{F}{\mu}}
$$

where $f_0$ is the fundamental frequency, $L$ is the sounding length, $F$ is the force, and $\mu$ is the mass per unit length.

In [The Science of Music](https://public.websites.umich.edu/~mejn/tsom/index.html), Mark Newman gives a more convenient form of this equation, assuming the strings are cylinders with constant density:
$$
f_0=\frac{1}{Ld}\sqrt{\frac{T}{\pi\rho}}
$$

where $d$ is the string diameter, $T$ is the tension, and $\rho$ is the density. This is the version we'll use.

## Fretting and Temperaments

Clavichords can be divided into two groups: fretted and unfretted. A fretted clavichord has multiple keys that share the same string (or group of strings). An unfretted clavichord has dedicated strings for each key. Most early clavichords were fretted, since they were easier to build, due to requiring fewer strings. An obvious disadvantage of fretted clavichords is you can't play multiple keys that share a string at the same time, which instrument makers tried to mitigate by fretting keys that aren't typically played together.

Another disadvantage, which was of interest to Mersenne, is you can't change the [temperament](https://en.wikipedia.org/wiki/Musical_temperament) of the clavichord. In Mersenne's day, the most common temperament was [meantone temperament](https://en.wikipedia.org/wiki/Meantone_temperament)[^3]. Mersenne was an early advocate of [equal temperament](https://en.wikipedia.org/wiki/Equal_temperament)[^4], which is the most common temperament used today.

With an unfretted clavichord, you can change the temperament by adjusting the tension on each string so the corresponding key is in tune. But with a fretted clavichord, changing the tension on a string affects all the keys that share that string, which means you can't tune each key independently. Sometimes you can work around that by bending the tangents sideways to alter the sounding length, but that quickly ruins the key levers. To change the temperament on a fretted clavichord without damaging it, you need to reposition the tangents and key levers.

## Solving for the Sounding Length

How does this model know where to position the key levers and tangents? First, let's revisit Mersenne's laws. We know that for fretted keys, we must keep the tension and density of the string constant for every key sharing that string, so let's solve for that. Let $f_0(i)$ be the fundamental frequency for the key at index $i$:
$$
\begin{aligned}
f_0(i)=\frac{1}{L(i)d}\sqrt{\frac{T(i)}{\pi\rho(i)}} \\
\sqrt{\frac{T(i)}{\pi\rho(i)}}=f_0(i)L(i)d
\end{aligned}
$$

Now, let's calculate the frequency for an adjacent fretted key at index $i+1$:
$$
\begin{aligned}
f_0(i+1) &=\frac{1}{L(i+1)d}\sqrt{\frac{T(i)}{\pi\rho(i)}}\\
       &=\frac{1}{L(i+1)d}f_0(i)L(i)d\\
       &=\frac{f_0(i)L(i)d}{L(i+1)d}\\
       &=\frac{f_0(i)L(i)}{L(i+1)}
\end{aligned}
$$

We can now easily solve for the sounding length of the key at index $i+1$:
$$
\begin{aligned}
L(i+1) &=\frac{f_0(i)L(i)}{f_0(i+1)}
\end{aligned}
$$

## Solving for the Tangent Position

Once we have the sounding length, we need to use that to determine the position of the tangents. The $x$ coordinate of the tangent is related to the sounding length and the $x$ coordinate of the bridge:
$$
T_x(i) = B_x(i) - L(i)
$$

Substituting the equation for $L(i+1)$ above, we end up with:
$$
\begin{aligned}
T_x(i+1) &= B_x(i+1) - L(i+1) \\
            &= B_x(i+1) - \frac{f_0(i)L(i)}{f_0(i+1)} \\
            &= B_x(i+1) - \frac{f_0(i)(B_x(i) - T_x(i))}{f_0(i+1)} \\
\end{aligned}
$$

This is the final equation implemented by the `tangentXForKeyFn()` function in [string_utils.kcl](./string_utils.kcl).

```rust
export fn tangentXForKeyFn(@keyIdx) {
  return if keyIdx == 0 {
    // Low C has fixed position relative to the toolbox
    toolboxLength + 10mm
  } else if courseIdxForKey(keyIdx) == courseIdxForKey(keyIdx - 1) {
    // Fretted key. Calculate the sounding length using Mersenne's laws.
    bridgeXForKey(keyIdx) - (
      frequencyForKey(keyIdx - 1) * (
        (bridgeXForKey(keyIdx - 1) - tangentXForKeyFn(keyIdx - 1))
        / frequencyForKey(keyIdx)
      )
    )
  } else {
    // Unfretted key. Just use fixed spacing from the previous tangent.
    tangentXForKeyFn(keyIdx - 1) + tangentSpacing()
  }
}
```

[^1]: The [Wikipedia article used to claim](https://en.wikipedia.org/w/index.php?title=Clavichord&oldid=1343076520#History_and_use) it was invented in the early 14th century, but this isn't supported by the sources it cites, so I changed it. Both works it cites (Bernard Brauchli's "The Clavichord" and Susi Jeans's "The pedal clavichord and other practice instruments of organists") state that the first unambiguous evidence was in the early 15th century, though this is complicated by the fact literary sources of that time use the terms "clavichord" and "monochord" interchangeably. There are 14th-century sources that use the term "monochord" that could plausibly be referring to a clavichord, but this is speculation.
[^2]: Brauchli, Bernard (1998). "The Clavichord", pp. 1
[^3]: A. Malet and D. Cozzoli, “Mersenne and Mixed Mathematics,” Perspectives on Science, vol. 18, no. 1, pp. 3, May 2010, doi: 10.1162/posc.2010.18.1.1.
[^4]: Bohn, Dennis A. (1988). "Environmental Effects on the Speed of Sound". Journal of the Audio Engineering Society. 36 (4): 223–231
[^5]: Rasch, Rudolf. (2006). Tuning and temperament. The Cambridge History of Western Music Theory. Unknown page.
[^6]: Barbour, J. M. (2004). "Tuning and Temperament: A Historical Survey." United States: Dover Publications. Page 98