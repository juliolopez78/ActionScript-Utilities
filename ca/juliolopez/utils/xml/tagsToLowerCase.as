/****************************************************************
TITLE:			tagsToLowerCase
AUTHOR:			Julio Lopez
LAST UPDATED: 	2011-01-15
DESCRIPTION:	A function for drawing arcs

****************************************************************/
package ca.juliolopez.utils.xml {
	
	public function tagsToLowerCase(n:XML):void {
		var attrs:XMLList;		//all attrs for a particular node
		var attr:XML			//an individual xml attr
		var kids:XMLList;		//all child nodes of an xml node
		var kid:XML;			//a particular child node of an xml node
		
		//change the tag's name
		n.setLocalName(n.localName().toString().toLowerCase());
		
		//get any attributes and child nodes
		attrs = n.attributes();
		kids = n.children();
		
		//if it has attributes, change their case too
		if (attrs.length() > 0) {
			//loop through the attrs
			for each(attr in attrs) {
				//make sure it is an attribute then change its name to lower case
				if (attr.nodeKind() == "attribute") {
					attr.setLocalName(attr.localName().toString().toLowerCase());
				}
			}
		}
		
		//if it has children and they are elements, change their tag case too
		if (kids.length() > 0) {
			//loop through the child nodes
			for each(kid in kids) {
				//make sure it is an element then change its case by calling this function with it as the param
				if (kid.nodeKind() == "element") {
					tagsToLowerCase(kid);
				}
			}
		}
	}
	
}