// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

if (typeof IntersectionObserver === 'function') {
    // IntersectionObserverをサポートしていないブラウザ（IE11など）では通常のローディングにフォールバック
    window.addEventListener('DOMContentLoaded', function () {
        var io = new IntersectionObserver(function (entries) {
                var that = this;
                entries.forEach(function (entry) {
                    if (entry.intersectionRatio === 0) return;
                    entry.target.src = entry.target.dataset.origsrc;
                    that.unobserve(entry.target);
                });
            },
            {
                // 画面外上下 100px まで来たら対象とする
                rootMargin: "100px 0px 100px 0px",
                threshold: [0.25],
            }
        );

        var imgs = document.querySelectorAll([
            'img.event-logo',
            'img.owner-icon',
            'img.user-icon'
        ].join(','));

        imgs.forEach(function (img) {
            img.dataset.origsrc = img.src;
            img.src = "/assets/loader-rolling.gif";
            io.observe(img);
        });
    });
}
