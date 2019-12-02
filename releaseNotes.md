#############################
## EVT 1.3 - RELEASE NOTES ##
#############################

* Added support for Chronological index for multiple <text>s edition. Information about date must be encoded in the <front> in a <date> element in a <docDate>; the date value must be encoded with a @when attribute:
```
	<front>
		<!-- [...] -->
		<docDate xml:id="CI_docDate">
			<date when="1212-04-02">1212 aprile 2</date>
		</docDate>
		<!-- [...] -->
	</front>
```

* Added support for translation level. 
  * Translation is available at document level, so no translations for single pages for now. 
  * Translation will be handled as additional edition level, thus in order to activate it, you must add ```<edition>Translation</edition>``` in the ```$edition_array``` variable of configuration file at the third position;
  * In the XML, the translation text must be encoded in the ```<back>``` of the ```<text>``` which it is referring to, in a ```<div type="translation">``` element (NB: the value of ```@type``` can also be ```"transl"```).

* Added support for prose/verse visualization for poetry. In order to activate it, set to ```true()``` the variable ```$prose_verses_toggler``` in the configuration file.
  
* Added support for ```<ref>``` and ```<ptr>``` inside HotSpots Pop-ups.

* Added support for Drama elements and for stage directions highlight.

* Added support for ```<editionStmt>``` in header info.

* Added support for list of terms and glosses (experimental functionalities).

* Added support for ```<figDesc>``` and ```<head>``` in an image linked to a pointer.

* Added the possibility of grouping by type the phenomena and entities to be highlighted in the text (More information in the documentation).
  
* Added the possibility to have a single navigation bar at the bottom of the page. To activate it, you just have to turn to ```true()``` the ```$bottom_navbar``` variable in the configuration file.

* Added minimum support for Viscoll [https://github.com/leoba/VisColl]. To activate it, you have to turn to ```true()``` the ```$viscoll_button``` variable in the configuration file and to indicate in ```$viscoll_info``` the path to the file containing the Viscoll data model.

* Improved UI performances.

* Added useful logs messages during first loading of the UI.

* Added translation in czech (special thanks to Karel Pacovský for this translation).

* Fixed bug concerning nude ```<lb/>``` elements, representing a real line break, not to be considered for image text linking feature.

* Fixed bug for latin terms in regesto. 

* Fixed bug for critical notes nested in ```<p>``` in regesto.

* Fixed bug for named entities without ```<forename>``` and ```<surname>```.

* Fixed bug concerning ```<back>``` text appearing in main text container.

* Fixed layout problem on list letters on small screen.
  
* Fixed behaviour of welcome popup.
  
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
