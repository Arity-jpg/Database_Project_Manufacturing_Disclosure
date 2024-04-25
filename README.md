# Author of this project
Alice Zimpfer, Matrikelnr.: 327090

-------------------------------------------
# Introduction
Sport product manufacturers 🏭 disclose details about their factories as a part of their marketing strategy for transparency. With the implementation of this database system, you can effortlessly access and compare information of renowned sport product brands as Nike, Adidas, VF Corporation and Puma. 🏀⚽👟
This database system is designed to investigate and understand factory details across those brands, making their manufacturing more transparent. 📊🌐 The data model intentionally abstracts away characteristics and relationships that are not crucial for problem solving. Ensuring an efficient representation of the real world of sport product manufacturing within the database design. 📊💻

------------------------------------------
# Database Systems Exam Project
This repository describes your examination task in our lecture **Database Systems**. In our current semester winter term 2023/2024, this is task is an extension to your written exam. The extension is meant to be carried out as an individual project. 

In addition to your project, you may receive a bonus on grading (of + 0,3; meaning the next better subgrade) if you attend two additional lectures in lecture series **Ringvorlesung Digitalisierung** or alternatively attend one of these lectures and respond (by share/like) to at least five of our social media posts (on [LinkedIn](https://www.linkedin.com/company/80157632) or [Instagram](https://www.instagram.com/hspf_wirtschaftsinfo/)).

## Project Overview
Our main goal (for all teams) will be to extend and update the mondial database used in our lecture. This idea was driven based on a arte documentation series called [Mit offenen Karten](https://www.arte.tv/de/videos/103960-020-A/mit-offenen-karten/) \(available in French and German\).

Your task is to choose a topic for extension and/or update of Mondial. You are free to choose any topic that makes sense. It is important that your topic can create a relationship to Mondial. Amongst others, you may use the following sources as basis to create ideas for extension/update:

1. [Our world in data](https://ourworldindata.org/)
2. [Wikipedia](https://www.wikipedia.org/)
3. [Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page)
4. [Mit offenen Karten](https://www.arte.tv/de/videos/RC-014036/mit-offenen-karten/)

Once you selected a topic, you must contact your lecturer (via Moodle) to make sure you are on track (meaningful contribution, project sized properly, ...). Besides your topic, this repository provides a general solution template that you must use to submit your results. Literally: all your results have to be pushed to your (this) repository.

> :bulb: **Inspiration for Your Project**  
> If you're looking for ideas for your project, consider checking out topics chosen by students in previous semesters. These might serve as a source of inspiration for you.  
> [Click here to view the past project topics](./topics.md)

## Project Tasks

1. Topic: Decide on your topic and how to contribute to Mondial.
1. Model: Create a model that covers your topic.
1. Data Ingestion: Insert and/or update data within Mondial.
1. Querying: Create interesting queries and views with regard to your topic.
1. Routines: Create interesting routines which are specific to your topic.
1. Documentation: Create a description of your steps and how your contribution will extend/update Mondial.

## Options
1. **Focus**: You may set a stronger emphasis on data (update) or on extension (new structures) or even handle both equally.
1. **Implementation**: You can create your extension on our university database server or you can use a local installation of Mondial. For this purpose we provide a Docker image which you may use, you can find it and usage instructions [here](https://github.com/thomas-schuster/docker-database).


## Template Structure
You will find a couple of folders each with a specific purpose (see below). Beware to only submit contents specific to each folder.

|Folder|Description| 
|----|----|
|[data](./data/README.md)| Your data which is ingested in your database has to be put here |
|[documentation](./documentation/README.md)| Your documentation must be placed here |
|[model](./model/README.md)| Your models (UML or ER) must be placed here |
|[routines](./routines/README.md)| All routines (procedures and functions) as well as triggers must be stored here |
|[queries](./queries/README.md)| Your queries in natural language, relational algebra and SQL must be put here. Similarly you may place views here. |

You will find a readme file in each folder. Please look into it for further instructions.

## Grading
Additional information about grading can be found in your syllabus. However, be aware that failing instructions partially or completely will be a reason for downgrading or failing the exam. Also, please be aware that the announced deadline for submission is strict, no exceptions! Be also aware that your final submission will automatically also indicate that you **accept** and **acknowledge academic integrity** and **student responsibility** as described in our syllabus (see Moodle).

For the subsections of your examination project you will find weights/points in the table below. Each category is graded according to creativity, correctness, and complexity of your solution.

|Topic|	Points|
|---|---|
|data|15|
|documentation|5|
|model|10|
|routines|10|
|queries|20|
|**total**|**60**|
