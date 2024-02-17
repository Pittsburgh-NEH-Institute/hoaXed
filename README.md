# hoaXed: a digital edition repository and tutorial

## About

hoaXed is a teaching tool intended to guide learners through the iterative development stages of creating a digital edition. The edition in this case is an eXist-db application, but the development stages are not unique to eXist-db or even to XQuery more generally. Using a model-view-controller design pattern to construct an application over eighteen stages, the edition shows learners how we start from our research questions and build an edition that is designed to explore them.

In order to create methodologically innovative editions, digital humanists must start from their research questions and be prepared to create bespoke interfaces and approaches that may not be available “out of the box” on existing edition-making platforms. For this reason, the hoaXed tutorial focuses on guiding users through an iterative approach to this type of development. The hoaXed edition uses XQuery and the tutorial includes some XQuery-specific instruction, it is not an XQuery tutorial. Some familiarity with XQuery is required, and for those not yet familiar with XQuery we refer or link to other materials that can help bring new learners up to speed.

This tutorial is an adaptation of an in-person workshop titled “Advanced digital editing: modeling the text and making the edition”, an NEH Institute for Advanced Topics in Digital Humanities. The workshop was held in July 2022 at the University of Pittsburgh, and the in-person teaching materials that we used there can be found at <https://pittsburgh-neh-institute.github.io/Institute-Materials-2020/>.

## How to use this tutorial

### GitHub Wiki

[The Wiki](https://github.com/Pittsburgh-NEH-Institute/hoaXed/wiki) for this project is made up of eighteen stages. Each stage is represented by a branch in the repository, which contains the code we write during that specific stage of development. We think of the staged code as a “fast forward” to the finished product in a cooking show. The tutorial shows you the ingredients and basic steps involved, and at the end a finished dish is presented. While this is not a perfect metaphor, we found it useful to provide a model for the iterative development (which in Real Life might happen over weeks or months) in a more compressed manner.

### Using the repository locally

To use a stage on your local machine, set up the prerequisite software described in [00-start-here](https://github.com/Pittsburgh-NEH-Institute/hoaXed/wiki/00-start-here). The next step is to clone this repository to your local machine. You can see a list of all the branches by typing `git branch -a` on the command line. When you want to change branches to move to the next stage, you can use `git checkout ##-stage-name` (e.g., `git checkout 00-start-here` to switch to Stage 0). If you do your development in VS Code that you’ve configured to synchronize your local files with an instance of eXist-db running on your local machine, you usually won’t need to rebuild and reinstall the hoaXed app after a new stage. There are a few exceptions to this (specifically, times when you need to tell eXist-db to reindex your data files, which doesn’t always happen automatically), and we’ll tell you when and how to that need when the need arises.

### Using this repository on GitHub

The best way to become comfortable with developing your own eXist-db app is to develop an eXist-db app, that is, to code along as you read the tutorial. If, though, you would prefer just to read along without cloning the repository and practicing the steps, you can navigate among the branches by using the Branches dropdown menu at the top of the “Code” tab on GitHub, as in the image below.

<img src="images/branch-menu.png" width="40%" alt="screenshot of the GitHub branch menu">

## Acknowledgements

<table style="border: none;">
    <tr style="border: none;">
        <td style="border: none; width: 30%;">
            <a href="https://www.neh.gov/"
                title="National Endowment for the Humanities: Exploring the Human Endeavour">
                <img align="left" width="156px" src="images/NEH-Preferred-Seal820.jpg" alt="NEH"
                    class="rpad"/>
            </a>
        </td>
        <td style="vertical-align: middle; border: none;"><em>Advanced digital editing: modeling the
                text and making the edition</em> is awarded by the NEH Office of Digital Humanities
            (ODH) and co-funded by the NEH Division of Research Programs. Any views, findings,
            conclusions, or recommendations expressed in materials developed for this project do not
            necessarily represent those of the National Endowment for the Humanities.</td>
    </tr>
</table>    
