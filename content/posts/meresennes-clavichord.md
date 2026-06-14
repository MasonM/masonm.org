---
title: "Modeling Mersenne's Clavichord"
date: 2026-06-14
author: Mason Malone
---

As a layman in machine learning, one of the most surprising developments recently has been the rise of Vision Language Models (VLMs) for CAD work.
I had assumed that the [symbol grounding problem](https://en.wikipedia.org/wiki/Symbol_grounding_problem) would be an insurmountable barrier for anything require precision modeling, yet there have been several CAD projects for doing exactly that.

One is [Zoo](https://zoo.dev/), a CAD program that integrates with a VLM to create 3D models using [KCL](https://zoo.dev/docs/kcl-book/intro.html), their domain-specific language.
The company behind Zoo hosted a design contest recently, so I decided to enter to see what it's capable of.
My submission, [Mersenne's Clavichord](https://zoo.dev/aquarium/8a3d0547-5ac6-41f7-82f4-90084e617db2) won first place. 
This post will walk through how I approached this model. But first:

## Background and History
### What's a clavichord?

The clavichord is a keyboard instrument that was invented at some point before 1404, and flourished for centuries in Europe.[^1]
It a was a highly expressive instrument, but too quiet for concert use, and gradually faded away with the rise of the piano.[^2]
Despite its weak sound, it was the preferred instrument for many composers, notably C.P.E. Bach, who considered it superior to the piano.[^3] 

I've been listening to classical music for over 20 years, but I was only vaguely aware of the clavichord until last year, when I randomly stumbled on the album [Clavichord Recital by Gustav Leonhardt](https://open.spotify.com/album/7cr4GFB8PtGqEa4KtfUtzO?si=00c4d272c07a4331).
I immediately fell in love with that album, but I began to wonder: why is this my first time hearing a clavichord?
I had heard Bach played on the piano countless times, yet never the clavichord, despite it being the instrument on which he likely wrote of this works. 

At first, I thought the answer was that the piano was simply a superior instrument, so there was no reason to perform Bach on the clavichord anymore.
But then in Leonhardt's performance of the Sonata in B Minor, I heard what sounded like vibrato.
"Surely that's a recording error", I thought, "everyone knows you can't do vibrato on a keyboard instrument." 
But I was wrong: unlike virtually every other keyboard instrument, you absolutely can perform vibrato on a clavichord, and it's a consequence of how the action works.

### Clavichord action

A clavichord action is a simple [class 1 lever](https://en.wikipedia.org/wiki/Lever#Types_of_levers), where one end of each key has a piece of metal called a "tangent".
When the other end of the key is pressed, the tangent rises and strikes the string. The distance between where the tangent strikes the string and the bridge is called the "sounding length" for that string.

{{< 3d-model
       src="/clavichord/models/clavichord_action_diagram.glb"
       camera-orbit="12deg 86.15deg 376.7m"
       caption="Clavichord action ([source code](https://github.com/MasonM/urbino_clavichord/blob/main/clavichord_action_diagram.scad))"
>}}

By rocking the key slightly, the player can alter the tension of the string for the duration of the note, which changes the pitch.
This is a form of vibrato unique to the clavichord, and is sometimes called "bebung".[^4]

### Why model a clavichord?

Even though there are still instrument makers keeping the art of clavichord building alive, many aspects of their construction have been lost to time. 
Several modern clavichord builders, such as [Peter Bavington](https://www.peter-bavington.co.uk/) and [Pierre Verbeek](https://harpsichords.weebly.com/), have done extensive work to rediscover these lost techniques.

Verbeek is an engineer and physicist who turned to clavichord construction in 2004. In 2011, he published a paper titled ["The Urbino Clavichord Revisted"](https://harpsichords.weebly.com/uploads/2/5/0/1/25019733/verbeek_urbino_magnano_nov_2011_ver09_pub.pdf), in which he reverse-engineered how a 15th-century clavichord was built by analyzing an intarsia depicting it.

Verbeek's paper fascinated me, partly because it treated clavichord reconstruction as a puzzle to be solved, and partly from his creative use of math and physics.
Unlike every other paper I've read, Verbeek included a plethora of measurements and technical drawings.
Still, even with all these details, I had trouble visualizing certain aspects of the instrument.
It's very difficult to accurately describe something as complex as a clavichord using only prose and technical drawings, 

These days, engineers have largely migrated from technical drawings to CAD software. CAD software has many advantages for describing the kind of objects engineers typically work with:
1. Accuracy. CAD models can express measurements to an arbitrary level of precision.
2. Easy modification. The clavichord action diagram shown above is a simplified version of the one shown below. 
3. Error checking. Most CAD software lets you express the different parts of an object in terms of constraints and equations, which it will check for you automatically.
4. Visualization. Nearly all CAD programs let you quickly render a 3D model. They say a photograph is worth a thousands words, and one can say the same about 3D models and technical drawings.

Although clavichords are clearly not the kind of objects engineers typically work with, all these advantages are just as applicable to the work of people like Verbeek and Bavington.
As far as I know, nobody has created CAD models of clavichords before, so I took it upon myself to turn Verbeek's paper into a model using [OpenSCAD](https://openscad.org/). The result is shown below:
{{< 3d-model
       src="/clavichord/models/urbino_clavichord.glb"
       camera-orbit="-20.92deg 44.33deg 1300m"
       caption="The Urbino clavichord ([source code](https://github.com/MasonM/urbino_clavichord/blob/main/clavichord.scad))"
>}}


I haven't built this (or any) clavichord before, so it's likely I made mistakes. If you notice any, please [contact me](mailto:masone@masonm.org)! All the models and code I used to generate these models are open-source and licensed under a permissive license.

### Who is Mersenne?

For the contest, the clavichord I decided to model was described by the French polymath [Marin Mersenne](https://en.wikipedia.org/wiki/Marin_Mersenne) in his 1636 treatise [Harmonie universelle](https://en.wikipedia.org/wiki/Harmonie_universelle).

If you're a programmer like me, you've probably heard of "Mersenne primes": prime numbers of the form \(M_n = 2^n -1\). Mersenne primes were one of Meresenne's many contributions to math, but the application of math to music was what interested him the most.[^5]
Mersenne sought to establish a science of music, and his work formed the root of modern acoustics.[^6] 

## Modeling the clavichord

### First Attempt

{{< figure
       src="/clavichord/images/mersennes_clavichord_cropped.png"
       alt="Drawing of the clavichord from Harmonie universelle"
       width="400"
       caption="Drawing of the clavichord from Harmonie universelle"
>}}
### Case
### Keyboard

#### Mersenne's Laws

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

#### Fretting and Temperaments

Clavichords can be divided into two groups: fretted and unfretted. A fretted clavichord has multiple keys that share the same string (or group of strings). An unfretted clavichord has dedicated strings for each key. Most early clavichords were fretted, since they were easier to build, due to requiring fewer strings. An obvious disadvantage of fretted clavichords is you can't play multiple keys that share a string at the same time, which instrument makers tried to mitigate by fretting keys that aren't typically played together.

Another disadvantage, which was of interest to Mersenne, is you can't change the [temperament](https://en.wikipedia.org/wiki/Musical_temperament) of the clavichord. In Mersenne's day, the most common temperament was [meantone temperament](https://en.wikipedia.org/wiki/Meantone_temperament).[^3] Mersenne was an early advocate of [equal temperament](https://en.wikipedia.org/wiki/Equal_temperament), which is the most common temperament used today.[^4]

With an unfretted clavichord, you can change the temperament by adjusting the tension on each string so the corresponding key is in tune. But with a fretted clavichord, changing the tension on a string affects all the keys that share that string, which means you can't tune each key independently. Sometimes you can work around that by bending the tangents sideways to alter the sounding length, but that quickly ruins the key levers. To change the temperament on a fretted clavichord without damaging it, you need to reposition the tangents and key levers.

#### Solving for the Sounding Length

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

#### Solving for the Tangent Position

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
### Bridges


## What's Next?

[^1]: Until I edited it, the [Wikipedia article on the clavichord](https://en.wikipedia.org/wiki/Clavichord) claimed it was invented in the early 14th century. I read both sources it cited, and neither substantiates that claim. Both state that the first unambiguous evidence was in the early 15th century. It's probable it was invented earlier, but exact dating is difficult because literary sources of that time used the terms "clavichord" and "monochord" interchangeably.
[^2]: Brauchli, Bernard (1998). "The Clavichord", pp. 1
[^3]: Ibid., 216-217
[^4]: Ibid., 267
[^5]: A. Malet and D. Cozzoli, “Mersenne and Mixed Mathematics,” Perspectives on Science, vol. 18, no. 1, pp. 3, May 2010, doi: 10.1162/posc.2010.18.1.1.
[^6]: Bohn, Dennis A. (1988). "Environmental Effects on the Speed of Sound". Journal of the Audio Engineering Society. 36 (4): 223–231
[^7]: Rasch, Rudolf. (2006). Tuning and temperament. The Cambridge History of Western Music Theory. 
[^8]: Barbour, J. M. (2004). "Tuning and Temperament: A Historical Survey." United States: Dover Publications. Page 98