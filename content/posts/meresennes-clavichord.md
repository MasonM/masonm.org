---
title: "Modeling Mersenne's Clavichord"
date: 2026-06-14
author: Mason Malone
description: TODO
---

## Introduction

As a layman in machine learning, one of the most surprising developments recently has been the rise of Vision Language Models (VLMs) for CAD work.
I had assumed that the [symbol grounding problem](https://en.wikipedia.org/wiki/Symbol_grounding_problem) would be an insurmountable barrier for anything require precision modeling, yet there have been several CAD projects for doing exactly that.

One is [Zoo](https://zoo.dev/), a CAD program that integrates with a VLM to create 3D models using [KCL](https://zoo.dev/docs/kcl-book/intro.html), their DSL (domain-specific language).
The company behind Zoo hosted a design contest recently, so I decided to enter to see what it's capable of.
My submission, [Mersenne's Clavichord](https://zoo.dev/aquarium/8a3d0547-5ac6-41f7-82f4-90084e617db2) won first place. 
This post will walk through how I approached this model.

## Background and History

### What's a clavichord?

The clavichord is a keyboard instrument that was invented at some point before 1404, and flourished for centuries in Europe.[^1]
It a was a highly expressive instrument, but too quiet for concert use, and gradually faded away with the rise of the piano.[^2]
Despite its weak sound, it was the preferred instrument for many composers, notably C.P.E. Bach, who considered it superior to the piano in many respects.[^3] 

I've been listening to classical music for over 20 years, but I was only vaguely aware of the clavichord until last year, when I randomly stumbled on the album [Clavichord Recital by Gustav Leonhardt](https://open.spotify.com/album/7cr4GFB8PtGqEa4KtfUtzO?si=00c4d272c07a4331).
I immediately fell in love with that album, but I began to wonder: why is this my first time hearing a clavichord?
I had heard Bach played on the piano countless times, yet never the clavichord, despite it being the instrument on which he likely wrote many (if not most) of this works. 

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
       style="height: 400px; background-color: #ffffff"
       interaction-prompt="auto"
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
As far as I know, nobody has created CAD models of clavichords before, so I took it upon myself to turn Verbeek's paper into a model using [OpenSCAD](https://openscad.org/). After several weekends of work, I ended up with this:
{{< 3d-model
       src="/clavichord/models/urbino_clavichord.glb"
       camera-orbit="-20.92deg 44.33deg 1300m"
       caption="The Urbino clavichord ([source code](https://github.com/MasonM/urbino_clavichord/blob/main/clavichord.scad)) ([interactive editor](https://masonm.org/urbino_clavichord.html))"
       style="height: 400px"
       interaction-prompt="auto"
>}}

### OpenSCAD and Zoo

As much as I love OpenSCAD, I hesitate to recommend it to non-programmers, which is approximately 99% of early music historians.
OpenSCAD is designed for programmers: all geometry is expressed using a [declarative DSL](https://openscad.org/cheatsheet/), and the editor provides little help in translating your ideas into code.
Although the learning curve isn't as steep as some other CAD programs, it's still considerable for someone without a programming background.

Like OpenSCAD, Zoo is also code-based, but includes several features to make it more accessible to non-programmers. The editor is far more intuitive and interactive, allowing point-and-click editing that automatically generates the appropriate code.
More interestingly, it integrates with a VLM called [Zookeeper](https://zoo.dev/zookeeper), which can take plain English prose and translate it directly to code.

### Who is Mersenne?

For the contest, the clavichord I decided to model was described by the French polymath [Marin Mersenne](https://en.wikipedia.org/wiki/Marin_Mersenne) in his 1636 treatise [Harmonie universelle](https://en.wikipedia.org/wiki/Harmonie_universelle).
{{< figure
       src="/clavichord/images/mersennes_clavichord_cropped.webp"
       alt="Mersenne's drawing of the clavichord"
       caption="Mersenne's drawing of the clavichord"
       width="400"
       link="/clavichord/images/mersennes_clavichord_cropped.webp"
       target="_blank"
>}}

If you're a programmer like me, you've probably heard of "Mersenne primes": prime numbers of the form \(M_n = 2^n -1\). Mersenne primes were one of Meresenne's many contributions to math, but the application of math to music was what interested him the most.[^5]
Mersenne sought to establish a science of music, and his work formed the root of modern acoustics.[^6] 

## Modeling the clavichord

### First Attempt

To start, I tried feeding Zookeeper the drawing shown above, along with Mersenne's description in the original French. How did it do?

{{< figure
       src="/clavichord/images/first_attempt.webp"
       alt="Result of giving Zookeeper the original diagram/description"
       width="600"
       link="/clavichord/images/first_attempt.webp"
       target="_blank"
>}}

In a word: poorly.
But expecting Zookeeper to generate a plausible instrument from Mersenne's sparse and ambiguous description is unreasonable, because until relatively recently, no human could either.
Some scholars even expressed doubt whether Mersenne was describing an actual instrument, or simply something he imagined.[^7] 

It wasn't until Peter Bavington built a reconstruction in ~2011 that it was clear the instrument Mersenne described was plausible and coherent.
Bavington explained his reconstruction in his excellent paper [Reconstructing Mersenne's Clavichord](https://www.peter-bavington.co.uk/Mersennepaper.pdf), which formed the basis of my attempts moving forward.
Without Bavington's work, this model wouldn't have been possible.

### Case

I decided to break up the model into discrete components and model each separately, starting with the case. Bavington provided exact dimensions on the case in [Paris inches](https://en.wikipedia.org/wiki/Paris_inch), which I converted to millimeters and put into a [params.kcl](https://github.com/MasonM/mersennes_clavichord/blob/main/params.kcl) file.  

Then, I asked Zookeeper to generate the code for the five wooden boards that make up the case. [The result it gave me](https://github.com/MasonM/mersennes_clavichord/commit/ced92cade071bbdae9460aaf3163039ab7eb18ed) was a good start, but needed manual editing. 
Zookeeper tends to avoid code reuse, so to make edits easier, I created a [`cube()` helper inspired by OpenSCAD](https://github.com/MasonM/mersennes_clavichord/blob/eec793b1ff8edffd8e232627203b08a27487e058/utils.kcl#L7C1-L33C2) and refactored the case to use that for 4 out of the 5 boards. 

{{< 3d-model
       src="/clavichord/models/case.glb"
       caption="Case ([source code](https://github.com/MasonM/mersennes_clavichord/blob/main/case.kcl))"
       style="height: 400px"
       camera-orbit="-18.06deg 53.79deg 2.571m" 
       interaction-prompt="none"
>}}

### Toolbox and Right Compartment

The left-side of the clavichord has a rectangular toolbox, which was typically used to hold spare parts and tools.
Bavington's reconstruction had a lid on the toolbox with a knob to open it, which I reproduced here.
I didn't know the appropriate terminology for the ornamentation around the lid, so I told Zookeeper to created a "stepped terrace" effect, with three steps leading to the base. Zookeeper handled that well.

I was also unsure of the terminology for the compartment to the right of the toolbox, so I called it the "right compartment". It shares the same ornamentation as the toolbox, but without a knob.

{{< 3d-model
       src="/clavichord/models/toolbox_right_compartment.glb"
       caption="Toolbox ([source](https://github.com/MasonM/mersennes_clavichord/blob/main/toolbox.kcl)) and right compartment ([source](https://github.com/MasonM/mersennes_clavichord/blob/main/right_compartment.kcl))"
       style="height: 400px"
       camera-orbit="-18.06deg 53.79deg 2.571m" 
       interaction-prompt="none"
>}}


### Soundbox

The soundbox consists of the soundboard, the wrestplank, and the belly rail. The wrestplank holds tuning pins for all 70 strings, the soundboard acts as a diaphragm to transform vibrations into acoustic energy, and the belly rail supports the soundboard, with 7 openings to allow the sound to escape.

These were straightforward to model, as each part can be modeled using the `cube()` function described earlier. The openings in the belly rail were achieved by using the [subtract()](https://zoo.dev/docs/kcl-std/functions/std-solid-subtract) function to cut out 7 holes using cubes generated via [patternLinear3d()](https://zoo.dev/docs/kcl-std/functions/std-solid-patternLinear3d).

{{< 3d-model
       src="/clavichord/models/soundbox.glb"
       caption="Soundbox ([source](https://github.com/MasonM/mersennes_clavichord/blob/main/soundbox.kcl))"
       style="height: 400px"
       camera-orbit="-18.06deg 53.79deg 2.571m" 
       interaction-prompt="none"
>}}

### Keyboard

The clavichord has 49 keys, ranging from \(C_2\) to \(C_4\), with a standard 12-note octave.
The number of octaves is therefore \(\lfloor \frac{49}{12}\rfloor=4\), the number of natural keys is \(4*7+1=29\), and the number of accidental keys is \(4*5=20\).

To find the $x$ coordinate of a natual key at index $naturalIdx$, we can simply multiply the index by the width of each natural key, which we can calculate by dividing the keywell length by the number of keys, and adding that to an offset $keyStartX$. Here's the resulting KCL code:
```rust
fn naturalKeyX(@naturalIdx) {
  return keyStartX + naturalIdx * keywellLength / numNaturalKeys
}
```

To find the $x$ coordinate of an accidental at index $accidentalIdx$, we can reuse $naturalKeyX()$ if we can find the index of an adjacent natural key.
Since each octave is the same, all we need to do is solve this for the first octave, since we can extrapolate to the others using [modular arithmetic](https://en.wikipedia.org/wiki/Modular_arithmetic).

Let's number each natural and accidental key for the first octave so we can determine how to map between the two:
{{< svg src="/images/keyboard_one_octave.svg" >}}

When $accidentalIdx<2$, then the adjacent natural key to the left has the same index. When $2<=accidentalIdx<=4$, then the closest natural key has the index $accidentalIdx+1$.
Translating this to KCL is straightforward:
```rust
adjNaturalIdxFirstOctave = [0, 1, 3, 4, 5]
fn accidentalAdjNaturalIdx(@accidentalIdx) {
  octaveIdx = floor(accidentalIdx / 5)
  accidentalIdxInOctave = accidentalIdx % 5
  return octaveIdx * 7 + adjNaturalIdxFirstOctave[accidentalIdxInOctave]
}

fn accidentalKeyX(@accidentalIdx) {
  baseNaturalIdx = accidentalAdjNaturalIdx(accidentalIdx)
  return naturalKeyX(baseNaturalIdx + 1) - (accidentalKeyWidth / 2)
}
```
Now that we can calculate the coordinate of each key, we can model them using the `cube()` function and position them using [translate()](https://zoo.dev/docs/kcl-std/functions/std-transform-translate). 
Initially, I used the [map()](https://zoo.dev/docs/kcl-std/functions/std-array-map) function to transform an array of key indices to cubes, but I rewrote it to use [patternTransform()](https://zoo.dev/docs/kcl-std/functions/std-solid-patternTransform) for performance.

{{< 3d-model
       src="/clavichord/models/keyboard.glb"
       caption="Keyboard ([source](https://github.com/MasonM/mersennes_clavichord/blob/main/keyboard.kcl))"
       style="height: 400px"
       camera-orbit="-18.06deg 53.79deg 2.571m" 
       interaction-prompt="none"
>}}

### Strings and Bridges

#### Strings
The clavichord has 70 strings in groups of two. Each group is called a "course", and each tangent strikes a single course. 
But wait, how can there be 49 keys and only 35 courses?

The answer is that this clavichord is *fretted*, which means multiple tangents share a single course. Most early clavichords were fretted, since they were easier to build and maintain. An obvious disadvantage of fretted clavichords is you can't play multiple keys that share a course at the same time, which instrument makers tried to mitigate by fretting keys that aren't typically played together.

Mersenne's description of which keys were fretted is highly ambiguous. I used Bavington's interpretation:[^8]
> If we take account of the fact that notes 41 [e2] and 46 [a2] are not included, the most likely meaning is that the top octave is fretted as follows:
>
>      c2–c#2 / d2–e♭2 / e2 (alone) / f 2–f#2 / g2–g#2 / a2 (alone) / b♭2–b2–c3 (three together).
> ...
>
> Both Boxall and Brauchli propose that the fretting continued downwards with the same pattern until the 18th course (f–f#), in which case the number of notes and courses matches very nicely; this seemed the most likely solution, and I planned the reconstruction accordingly.

Zookeeper translated that description into [this KCL function](https://github.com/MasonM/mersennes_clavichord/blob/662629c9f6fc161ece2cd8dec83e763ab1c6bded/string_utils.kcl#L74-L93), which is perhaps a bit overcomplicated, but perfectly functional.

The strings themselves are simple cylinders with a diameter of 0.7mm, and I created a [OpenSCAD-inspired cylinder() function](https://github.com/MasonM/mersennes_clavichord/blob/662629c9f6fc161ece2cd8dec83e763ab1c6bded/utils.kcl#L35-L50) to facilitate this.

#### Bridges

To support the strings, the clavichord has five bridges, which transfer vibrations to the soundboard. Thankfully, Mersenne's description of the bridges is much clearer (translation courtesy of Bavington):
> As for the bridges, the first carries six courses of strings, that is 12 [strings]. The second has 9 courses or 18, of which the first 8 are doubled and twisted together, so that there are 20 paired strings. The third bridge supports 8 courses, that is 16 [strings]. The fourth contains three courses or 6 strings, and the fifth has 9 courses: but one can make a single bridge instead of these five.

Again, Zookeeper quickly translated this [into a KCL function](https://github.com/MasonM/mersennes_clavichord/blob/662629c9f6fc161ece2cd8dec83e763ab1c6bded/string_utils.kcl#L37-L72).

While Zookeeper had absolutely no trouble with these kind of mathematical exercises, it did struggle slightly with the shape of the bridges, particularly with respect to the sloping edges.
The result I ended up seems fairly close to Bavington's reproduction.
Not having built a clavichord myself, I'm unsure how important the shape of the bridges really is, but I hope to find out soon!

{{< 3d-model
       src="/clavichord/models/strings_and_bridges.glb"
       caption="Strings ([source](https://github.com/MasonM/mersennes_clavichord/blob/main/strings.kcl)) and bridges ([source](https://github.com/MasonM/mersennes_clavichord/blob/main/bridges.kcl))"
       style="height: 400px"
       camera-orbit="-18.06deg 53.79deg 2.571m" 
       interaction-prompt="none"
>}}

### Key Levers

This is where it gets slightly tricky. The key levers attach to the corresponding key and support a tangent at the far end, which must be positioned such that when the tangent rises, it strikes the string to create the appropriate sounding length for the key.
But how do we determine the sounding lengths for each key? Unlike Verbeek's paper, Bavington didn't include precise measurements for the sounding lengths. That means we need to calculate them ourselves.

#### Mersenne's Laws

Thankfully, Mersenne gave us the tools to do this! The sounding length is related to the [fundamental frequency](https://en.wikipedia.org/wiki/Fundamental_frequency), the tension of the string, and the mass per unit length of the string. 
Mersenne was the first to discover and prove the mathematical relationship between these variables, which is now known as [Mersenne's laws](https://en.wikipedia.org/wiki/Mersenne%27s_laws). The usual form of this relationship is given as:
$$
f_0=\frac{1}{2L}\sqrt{\frac{F}{\mu}}
$$

where $f_0$ is the fundamental frequency, $L$ is the sounding length, $F$ is the force, and $\mu$ is the mass per unit length.

In [The Science of Music](https://public.websites.umich.edu/~mejn/tsom/index.html), Mark Newman gives a more convenient form of this equation, assuming the strings are cylinders with constant density:
$$
f_0=\frac{1}{Ld}\sqrt{\frac{T}{\pi\rho}}
$$

where $d$ is the string diameter, $T$ is the tension, and $\rho$ is the density. This is the version we'll use.

#### Calculating the frequency

The frequency for each key is determined by the [temperament](https://en.wikipedia.org/wiki/Musical_temperament) of the clavichord.
In Mersenne's day, the most common temperament was [meantone temperament](https://en.wikipedia.org/wiki/Meantone_temperament).[^9]
Mersenne was an early advocate of [equal temperament](https://en.wikipedia.org/wiki/Equal_temperament), which is the most common temperament used today.[^10] Mersennes proposed the following as the ratio of an equal-tempered semitone:[^11]
$$
\sqrt[4]{\frac{2}{3-\sqrt{2}}}
$$

The model includes both temperaments. For meantone, the following KCL code calculates the frequency for the key at index $keyIdx$:
```rust
meantonePitchClassRatios = [
  1,
  5 ^ (7 / 4) / 16,
  5 ^ (1 / 2) / 2,
  4 / (5 ^ (3 / 4)),
  5 / 4,
  2 / (5 ^ (1 / 4)),
  5 ^ (3 / 2) / 8,
  5 ^ (1 / 4),
  25 / 16,
  5 ^ (3 / 4) / 2,
  4 / (5 ^ (1 / 2)),
  5 * 5 ^ (1 / 4) / 4
]
fn meantonePitchRatioForKey(@keyIdx) {
  octaveIdx = floor(keyIdx / 12)
  pitchClassIdx = keyIdx % 12
  return meantonePitchClassRatios[pitchClassIdx] * 2 ^ octaveIdx
}

referencePitchA1 = 392
referenceA1OctaveIdx = 2
referenceA1PitchRatio = 5 ^ (3 / 4) / 2 * 2 ^ referenceA1OctaveIdx
fn meantoneFrequencyForKey(@keyIdx) {
  return referencePitchA1 * meantonePitchRatioForKey(keyIdx) / referenceA1PitchRatio
}
```

The code for equal temperament is much simpler:
```rust
equalTemperedSemitoneInterval = (2 / (3 - (2 ^ (1 / 2)))) ^ (1 / 4)
referenceA1KeyIdx = 33
fn equalTemperedFrequencyForKey(@keyIdx) {
  return referencePitchA1 * equalTemperedSemitoneInterval ^ (keyIdx - referenceA1KeyIdx)
}
```

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
fn tangentXForKeyFn(@keyIdx) {
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

{{< 3d-model
       src="/clavichord/models/key_levers_and_tangents.glb"
       caption="Key levers ([source](https://github.com/MasonM/mersennes_clavichord/blob/main/key_levers.kcl)) and tangents ([source](https://github.com/MasonM/mersennes_clavichord/blob/main/tangents.kcl))"
       style="height: 400px"
       camera-orbit="-18.06deg 53.79deg 2.571m" 
       interaction-prompt="none"
>}}

### All the rest

{{< 3d-model
       src="/clavichord/models/mersennes_clavichord.glb"
       caption="The final model ([source](https://github.com/MasonM/mersennes_clavichord/blob/main/main.kcl))"
       style="height: 400px"
       camera-orbit="-18.06deg 53.79deg 2.571m" 
       interaction-prompt="none"
>}}
### What's Missing?


## What's Next?


## Conclusion

I haven't built this (or any) clavichord before, so it's likely I made mistakes. If you notice any, please [contact me](mailto:masone@masonm.org)! All the code I used to generate these models are open-source and licensed under a permissive license.

[^1]: Until I edited it, the [Wikipedia article on the clavichord](https://en.wikipedia.org/wiki/Clavichord) claimed it was invented in the early 14th century. I read both sources it cited, and neither substantiates that claim. Both state that the first unambiguous evidence was in the early 15th century. It's probable it was invented earlier, but exact dating is difficult because literary sources of that time used the terms "clavichord" and "monochord" interchangeably.
[^2]: Brauchli, Bernard (1998). "The Clavichord", pp. 1
[^3]: Ibid., 216-217
[^4]: Ibid., 267
[^5]: A. Malet and D. Cozzoli, “Mersenne and Mixed Mathematics,” Perspectives on Science, vol. 18, no. 1, pp. 3, May 2010, doi: 10.1162/posc.2010.18.1.1.
[^6]: Bohn, Dennis A. (1988). "Environmental Effects on the Speed of Sound". Journal of the Audio Engineering Society. 36 (4): 223–231
[^7]: Edwin M. Ripin et al., Early Keyboard Instruments (London: Macmillan, 1989), p. 155.
[^8]: Bavington, Peter, "Reconstructing Mersenne's Clavichord". Page 12-13.
[^9]: Rasch, Rudolf. (2006). Tuning and temperament. The Cambridge History of Western Music Theory. 
[^10]: Barbour, J. M. (2004). "Tuning and Temperament: A Historical Survey." United States: Dover Publications. Page 98
[^11]: I got this from the [the Wikipedia article](https://en.wikipedia.org/wiki/Marin_Mersenne), but it doesn't cite its sources, and I'm having trouble locating one. The closest I've found is Rasch's "Tuning and Temperament", which gives Mersenne's string length tables, but not the closed-form equation. 