#############################
## EVT 1.2 - RELEASE NOTES ##
#############################

* Added support for integrations and editorial additions encoded with <supplied>, with particular attention to omissions (@reason="omitted") and illegible text (@reason="illegible");

* Added support for columns breaks (<cb>) and tables (<table>);

* Added support for <note>s that are not inline and are referenced in the text one or more times with the element <ptr/>;
* Added support for <ref>s whose @target attribute refers to a web page;

* Many bugs fixed!  


##############
## EXAMPLES ##
##############

* With this release we provide three different examples. The first one is the one that has already been transformed. If you want to have a look at the other examples you have to rename the corresponding configuration file as "evt_builder-config.xsl" and perfom a new transformation of the XML source file, following the instruction contained in the documentation.
(NB: remember to add a "_default" suffix to the current configuration file, in order to avoid losing the default configurations!).  


#### EXAMPLE 1 : Excerpt from Codice Pelavicino Digitale

	XML file: input_data/text/CodicePelavicino.xml
	Config file: config/evt_builder-config_CP.xsl

#### EXAMPLE 2 : Excerpt from The Digital Vercelli Book

	XML file: input_data/text/DOTR.xml
	Config file: config/evt_builder-config_DOTR.xsl

#### EXAMPLE 3 : Mixed examples of TEI Embedded Transcription

	XML file: input_data/text/ET_mixedExamples.xml
	Config file: config/evt_builder-config_ET_mixedExamples.xsl
