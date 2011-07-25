;;
(function(RightJS) {
	var R = RightJS,
	$ = RightJS.$,
	$$ = RightJS.$$,
	$E = RightJS.$E,
	Xhr = RightJS.Xhr,
	Object = RightJS.Object;

	String.include({
		to_slug: function() {
			str = Object.clone(this);
			str = str.replace(/^\s+|\s+$/g, '').toLowerCase();

			// remove accents, swap ñ for n, etc
			var from = "àáäâèéëêìíïîòóöôùúüûñç·/_,:;";
			var to = "aaaaeeeeiiiioooouuuunc------";
			for (var i = 0, l = from.length; i < l; i++) {
				str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
			}
			str = str.replace(/[^a-z0-9 -]/g, '').replace(/\s+/g, '-').replace(/-+/g, '-');
			return str;
		}
	});

	$(document).onReady(function() {
		if ($('advanced')) {
			$$('#advanced>div').each('toggle');
			$$('#advanced>legend').first().on('click', function(e) {
				this.parent().find('div').each('toggle');
			});
		}

		$$('.invalid').each(function() {
			this.parent().find('label').setStyle({
				color: 'red'
			});
		});

		if ($$('input[name*="[tag_list]"]').length) {
			var el = $$('input[name*="[tag_list]"]').first();
			el.setStyle({
				color: el.getStyle('background-color')
			});

			Xhr.load('/base/tagblob.js', {
				onSuccess: function(r) {
					new Tags(el, {
						vertical: true,
						tags: r.responseJSON
					});
				}
			});
		}

		$$('input[type=file]').each(function(el) {
			var myid = el.get('id'),
			myname = $(el).get('name');
			var input = new Element('input', {
				type: "hidden",
				value: myname
			});
			var div = new Element('div', {
				id: myid,
				class: "upload_button",
				html: "Upload"
			});
			el.parent().append(input, div)
			el.remove();

			var uploader = new qq.FileUploader({
				debug: true,
				element: div._,
				//html element
				action: '/base/upload',
				onComplete: function(id, name, resp) {
					if (resp.error) {
						var ul = new Element('ul', {
							class: "errors"
						});
						resp.error.each(function(el) {
							ul.append(new Element('li', {
								html: el
							}));
						});
						div.append(ul);
					} else {
						input.set('value', resp.success)
					}
				}
			});
		});

		var slug = $$('input[name*="[slug"]'); //$('input[name*="slug"').filter(function() { return this.id.match(/_slug[\(a-z\)]*/); });
		if (slug.length) {
			slug.each(function(el) {
				var title = el.get('name').replace(/slug/, 'title');
				function to_slug(event) {
					el.set('value', this.get('value').to_slug())
				};
				$$('input[name="' + title + '"]').each(function(el) {
					el.on({
						change: "to_slug",
						keyup: "to_slug",
						blur: "to_slug"
					});
				});
			});
		}

		if ($$("#taxonomy_parent_id").length) {
			$.getJSON('/taxonomy/tree.js', function(tree) {
				$('input[name=_dummy]').optionTree(tree, {
					choose: "Scegli...",
					preselect: {
						'_dummy': "---"
					}
				}).change(function() {
					$('input[name="taxonomy[parent_id]"]').set('value', this.get("value"));
				});
			});
		}

		$('site_link').set('href', 'http://' + /(\w+)(.\w+)?$/.exec(location.hostname)[0] + '/');

		/*(function() {
			if (!$$('textarea.text').length) return false;
			var rte_opts = {
				minimal: {
					toolbar: 'small',
					tags: {
						Bold: 'b',
						Italic: 'i',
						Underline: 'u',
						Strike: 's',
						Quote: 'blockquote',
					},

				},
				full: {}
			}
			$$('textarea.text').each(function(el) {
				new Rte(el, {});
			});
		})();*/

		(function() {
			if ($$('#hcard').length == 0) return;
			var template = _.template('<div id="<%= id %>" class="vcard">' + '  <span class="given-name"><%= given_name %></span>' + '  <span class="additional-name"><%= additional_name %></span>' + '  <span class="family-name"><%= family_name %></span>' + '  <% if (photo.length > 3) {%><img src="<%= photo %>" alt="photo of <%= given_name %> <%= additional_name %> <%= family_name %>" class="photo"/><% } %>' + '  <div class="org"><%= org %></div>' + '  <a class="email" href="mailto:<%= email %>"><%= email %></a>' + '  <div class="street-address"><%= street_address %></div>' + '  <span class="locality"><%= city %></span>' + '  <span class="region"><%= region %></span>' + '  <span class="postal-code"><%= postal_code %></span>' + '  <span class="country-name"><%= country %></span>' + ' <% _.each(phone,function(tel){%> <div class="tel"><%= tel %></div> <% }); %>' + '</div>');
			function fillCard(e) {
				var params = {
					given_name: $('givenname').get("value"),
					additional_name: $('additionalname').get("value"),
					family_name: $('familyname').get("value"),
					org: $('org').get("value"),
					email: $('email').get("value"),
					street_address: $("street").get("value"),
					city: $("city").get("value"),
					region: $("region").get("value"),
					postal_code: $("postal").get("value"),
					country: $("country").get("value"),
					phone: _.map($("phone").get("value").split(','), function(e) {
						return e.trim();
					}),
					photo: $("photo").get("value")
				};
				params.id = _.map([params.given_name, params.additional_name, params.family_name], function(el) {
					if (el) return el.replace(/\s+/g, '-');
					return null;
				}).join('-');

				$('target').html(template(params));
				$('hcard').set('value', template(params));
			}
			$$('form.card input').each(function(el) {
				el.on('change', fillCard);
				el.on('blur', fillCard);
				el.on('keyup', fillCard);
			});
			$$('form.card').each(function(el) {
				el.on('submit', fillCard);
			});
		})();
	});

	Rte.Tools.Image = new Class(Rte.Tool, {
		command: 'insertimage',
		attr: 'src',

		element: function() {
			var image = this.rte.selection.element();
			return image !== null && image.tagName === "IMG" ? image: null;
		},
		// the url-attribute 'src', 'href', etc.
		exec: function(url) {
			if (url === undefined) {
				this.prompt();
			} else {
				if (url) {
					this[this.element() ? 'url': 'create'](url);
				} else {
					this.rte.editor.removeElement(this.element());
				}
			}
		},

		active: function() {
			return this.element() !== null;
		},

		prompt: function() {
            var diag = new Dialog({
                closeable: false,
                title: 'Inserisci Immagine'
            });
            diag.load('/multimedia/dialog');
			var url = prompt(Rte.i18n.UrlAddress, this.url() || 'http://some.url.com');

			if (url !== null) {
				this.exec(url);
			}
		},

		// protected
		url: function(url) {
			if (this.element()) {
				if (url !== undefined) {
					this.element()[this.attr] = url;
				} else {
					return this.element()[this.attr];
				}
			}
		},

		create: function(url) {
			this.rte.selection.exec(this.command, url);
		}
	});

})(RightJS);

