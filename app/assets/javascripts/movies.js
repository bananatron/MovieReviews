(function($) {
    $.fn.extend( {
        limiter: function(limit, elem) {
            $(this).on("keyup focus", function() {
                setCount(this, elem);
            });
            function setCount(src, elem) {
                var chars = src.value.length;
                if (chars > limit) {
                    src.value = src.value.substr(0, limit);
                    chars = limit;
                }
                elem.html( limit - chars );
            }
            setCount($(this)[0], elem);
        }
    });
})(jQuery);
  
var elem = $("#chars");
$("#summary").limiter(140, elem);

var substringMatcher = function(strs) {
  return function findMatches(q, cb) {
    var matches, substrRegex;
    matches = [];
    substrRegex = new RegExp(q, 'i');
    $.each(strs, function(i, str) {
      if (substrRegex.test(str)) {
        matches.push({ value: str });
      }
    });
    cb(matches);
  };
};

function grabJSON(url) {
  return JSON.parse($.ajax({
     type: 'GET',
     url: url,
     dataType: 'json',
     global: false,
     async:false,
     success: function(data) {
         return data;
     }
  }).responseText);
}

var movies = grabJSON(movies_list_url);

$('#title .typeahead').typeahead({
  hint: true,
  highlight: true,
  minLength: 3
},
{
  name: 'movies',
  displayKey: 'value',
  source: substringMatcher(movies)
});

