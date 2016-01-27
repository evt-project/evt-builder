Introduction
=========== 

<br/>

###About EVT

EVT (Edition Visualization Technology) is a software for creating and browsing digital editions of manuscripts based on text encoded according to the TEI XML (http://www.tei-c.org/) schemas and Guidelines. This tool was born as part of the VBD (Digital Vercelli Book: http://vbd.humnet.unipi.it/) project in order to allow the creation of a digital edition of the Vercelli Book, a parchment codex of the late tenth century, now preserved in the Archivio e Biblioteca Capitolare of Vercelli and regarded as one of the four most important manuscripts of the Anglo-Saxon period as regards the transmission of poetic texts in the Old English language.
To ensure that it will be working on all the most recent web browsers, and for as long as possible on the World Wide Web itself, EVT is built on open and standard web technologies such as HTML, CSS and JavaScript. Specific features, such as the magnifying lens, are entrusted to jQuery plug-ins, again chosen among the open source and best supported ones to reduce the risk of future incompatibilities. The general architecture of the software, in any case, is modular, so that any component which may cause trouble or turn out to be not completely up to the task can be replaced easily.

###How it works
The basic idea of EVT is very similar to the modus operandi which is commonly used to convert TEI XML documents in HTML: when the main style sheet is applied to the document, it starts a processing which ends with a website containing the digital edition of the manuscript. Our ideal goal, in fact, is to have a simple, very user-friendly drop-in tool, requiring little work and/or knowledge of anything beyond XML from the editor. To reach this goal, EVT is based on a modular structure where a single style sheet (evt_builder.xsl) starts a chain of XSLT 2.0 transformations calling in turn all the other modules; the latter belong to two general categories: those devoted to building the HTML site, and the XML processing ones, which extract the edition text lying between folios using the `<pb/>` element and format it according to the edition level. All XSLT modules live inside the builder_pack folder, in order to have a clean and well organized directory hierarchy.

###Main features
At the present moment EVT can be used to create image-based editions with two possible edition levels: diplomatic and diplomatic-interpretative. This means that a transcription encoded using elements of the TEI transcr module (see chapter 11 Representation of Primary Sources in the Guidelines) should already be compatible with EVT, or require only minor changes to be made compatible. A search functionality has been added for all edition levels, and EVT also supports named entities and the handling of the corresponding lists. The Vercelli Book transcription is following the standard TEI schemas with no custom elements or attributes added: our tests with similarly encoded texts showed a high grade of compatibility. A critical edition level is being studied and it will be added in the future.
On the image side, several features such as a magnifying lens, a general zoom, image-text linking and more are already available. The image-text feature is inspired by Martin Holmes’ Image Markup Tool software and was implemented in XSLT and CSS by one of the students collaborating to the project; all other features are achieved by using jQuery plugins.


***
<br/>

A short guide to EVT
====================

<br/>
###Installation
EVT doesn't need an installation process: just uncompress the archive in a suitable folder and you are ready to go.
	
###Configuration
There are several ways to customize EVT, the most important one is to modify the builder_pack/modules/evt_builder-conf.xsl file to configure the existing parameters so that the UI layout matches your edition data. Refer to the EVT manual (doc folder) for more information about this file and other ways of customizing EVT's output.

###EVT Manual
In the "doc" folder you will find a preliminary version of the EVT manual, this should be your main reference to customize and use this tool.

###Feedback
Please send all comments, suggestions, bug reports etc. to roberto.rossellidelturco@gmail.com.
