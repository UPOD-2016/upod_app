/*
* This file must be included before mathjax is loaded for the effects to take place
* common configurations http://docs.mathjax.org/en/latest/config-files.html#common-configurations
* list of configuration options http://docs.mathjax.org/en/latest/options/hub.html#configure-hub
* author: Steven Swartz
*/
(function(){	

	window.MathJax = {
		jax: ["input/AsciiMath","output/CommonHTML"],
		
		//Using asciimath 
		extensions: ["asciimath2jax.js"], 
		
		//Require MathJax.Hub.Configured() to be called before configuring MathJax
		//We can avoid the overhead of configuration if we know there is no math on the page
		delayStartupUntil: "configured",
		
		//Identifies math by searching text within the delimters
		//Mathjax will also look for math in between script tags like: <script type='math/asciimath'>\pi</script>
		asciimath2jax: {
			delimiters: [['`','`']]
		},
		
		//Once configured, typeset immediately?
		skipStartupTypeset: true,
		
		
		showProcessingMessages: false,
		
		showMathMenu: false,
		//http://docs.mathjax.org/en/latest/reference/CSS-styles.html#css-style-objects
		//style information http://docs.mathjax.org/en/latest/options/CommonHTML.html
		styles: {
			".MathJax_CHTML": {
				"text-align": "center",
				"font-size" : "100%"
			}
		},
		displayAlign: "center",
		CommonHTML: {
			scale: 100
		},
		linebreaks: {
			automatic: true
		}
	};
})();