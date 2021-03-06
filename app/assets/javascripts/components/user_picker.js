$(document).on('ready page:load', function(){
  var REGEX_EMAIL = "([a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*@" +
                    "(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)";

  $("[data-selectize]").each(function(i, elem) {
    $(elem).selectize({
      maxItems: null,
      valueField: "email",
      labelField: "name",
      searchField: ["name", "email"],
      render: {
        item: function(item, escape) {
          return "<div>" +
            (item.name ? "<span class=\"name\">" + escape(item.name) + "</span>" : "") +
            (item.email ? "<span class=\"email\">" + escape(item.email) + "</span>" : "") +
          "</div>";
        },
        option: function(item, escape) {
          return "<div>" +
            "<span class=\"remets-pp--label\">" + escape(item.email) + "</span>" +
            (item.name ? "<span class=\"remets-pp--caption\">" + escape(item.name) + "</span>" : "") +
          "</div>";
        }
      },
      onInitialize: function() {
        $.each(this.$input.data("initial-items"), (i, v) => {
          this.addOption(v);
          this.addItem(v.email);
        })
      },
      createFilter: function(input) {
        var match, regex;

        // email@address.com
        regex = new RegExp('^' + REGEX_EMAIL + '$', 'i');
        match = input.match(regex);
        if (match) return !this.options.hasOwnProperty(match[0]);

        // name <email@address.com>
        regex = new RegExp('^([^<]*)\<' + REGEX_EMAIL + '\>$', 'i');
        match = input.match(regex);
        if (match) return !this.options.hasOwnProperty(match[2]);

        return false;
      },
      create: function(input) {
        if ((new RegExp('^' + REGEX_EMAIL + '$', 'i')).test(input)) {
          return {email: input};
        }
        var match = input.match(new RegExp('^([^<]*)\<' + REGEX_EMAIL + '\>$', 'i'));
        if (match) {
          return {
            email : match[2],
            name  : $.trim(match[1])
          };
        }
        alert('Invalid email address.');
        return false;
      },
      load: function(query, callback) {
        if (!query.length) return callback();
        $.ajax({
          url: "/acquaintances.json?q=" + encodeURIComponent(query),
          type: "GET",
          dataType: "json",
          error: function() {
            callback();
          },
          success: function(res) {
            callback(res.slice(0, 20));
          }
        });
      }
    });
  })
});
