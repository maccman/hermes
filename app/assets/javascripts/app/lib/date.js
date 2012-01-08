/**
 * date() function that behaves like the date() function in PHP.
 * Note: Uses milliseconds instead of seconds.
 *
 * Also adds format(f) and getWeekNumber() methods on instances of Date.
 *
 * Based on <http://stevenlevithan.com/assets/misc/date.format.js>
 * Rewritten by Andreas Blixt to match the PHP date() function.
 * 
 * License: MIT license <http://www.opensource.org/licenses/mit-license.php>
 * Project homepage: <http://github.com/blixt/js-date>
 * 
 * @author Andreas Blixt <andreas@blixt.org>
 * @author Steven Levithan <http://stevenlevithan.com>
 * @version 1.1
 */

Date.prototype.getWeekNumber = function () {
  var y = this.getFullYear();
  var m = this.getMonth();
  var d = this.getDate();

  var w1 = (this.getDay() + 6) % 7;
  var w2 = (new Date(y, 0, 1).getDay() + 6) % 7;
  var w3 = (new Date(y + 1, 0, 1).getDay() + 6) % 7;
  var w4 = w2;

  if (m == 0 && 3 < w2 && w2 < 7 - (d - 1)) {
    w1 = w2 - 1;
    w2 = new Date(y - 1, 0, 1);
    m = 11;
    d = 31;
  } else if (m == 11 && 30 - (d - 1) < w3 && w3 < 4) {
    return 1;
  }

  return Math.floor((w4 < 4) + 4 * m + (2 * m + (d - 1) + w2 - w1 + 6) * 36 / 256);
}

var date = function () {
    var
        token = /\\.|[dDjlNSwzWFmMntLoYyaABgGhHisueIOPTZcrU]/g,
        timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g,
        timezoneClip = /[^-+\dA-Z]/g,

        pad = function (value, length) {
            value = String(value);
            length = parseInt(length) || 2;
            while (value.length < length) value = '0' + value;
            return value;
        };

    return function (format, timestamp) {
        var d = timestamp ? (timestamp instanceof Date ? timestamp : new Date(timestamp)) : new Date();

        var
            G = d.getHours(),
            i = d.getMinutes(),
            j = d.getDate(),
            n = d.getMonth() + 1,
            o = d.getTimezoneOffset(),
            s = d.getSeconds(),
            u = d.getMilliseconds(),
            w = d.getDay(),
            W = d.getWeekNumber(),
            Y = d.getFullYear(),

            N = w || 7,
            z = Math.round((new Date(Y, n - 1, j) - new Date(Y, 0, 1)) / 86400000),

            flags = {
                // Day
                d: pad(j),
                D: date.i18n.dayNames[w],
                j: j,
                l: date.i18n.dayNames[w + 7],
                N: N,
                S: date.i18n.numericSuffixes[(j >= 11 && j <= 13) * 3 || Math.min((j - 1) % 10, 3)],
                w: w,
                z: z,
                // Week
                W: W,
                // Month
                F: date.i18n.monthNames[n - 1 + 12],
                m: pad(n),
                M: date.i18n.monthNames[n - 1],
                n: n,
                t: '?',
                // Year
                L: '?',
                o: '?',
                Y: Y,
                y: String(Y).substring(2),
                // Time
                a: G < 12 ? date.i18n.am : date.i18n.pm,
                A: G < 12 ? date.i18n.AM : date.i18n.PM,
                B: '?',
                g: G % 12 || 12,
                G: G,
                h: pad(G % 12 || 12),
                H: pad(G),
                i: pad(i),
                s: pad(s),
                u: u,
                // Timezone
                e: '?',
                I: '?',
                O: (o > 0 ? '-' : '+') + pad(Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60, 4),
                P: '?',
                T: (String(d).match(timezone) || ['']).pop().replace(timezoneClip, ''),
                Z: '?',
                // Full Date/Time
                c: '?',
                r: '?',
                U: Math.floor(d / 1000)
            };

        return format.replace(token, function ($0) {
            return $0 in flags ? flags[$0] : $0.substring(1);
        });
    };
}();

date.i18n = {
    am: 'am', pm: 'pm',
    AM: 'AM', PM: 'PM',
    dayNames: [
        'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat',
        'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
    ],
    monthNames: [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
        'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
    ],
    numericSuffixes: ['st', 'nd', 'rd', 'th']
};

Date.prototype.format = function (format) {
    return date(format, this);
};

Date.prototype.formatAgo = function(){
  var yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);
  
  if (this.getTime() < yesterday.getTime()) {
    // Yesterday
    return this.format('d/m/y');
  } else {
    return this.format('h:i a');    
  }
}