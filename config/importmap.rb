# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "ajax-form", to: "ajax-form.js", preload: true
pin "aos", to: "aos.js", preload: true
pin "bootstrap.min", to: "bootstrap.min.js", preload: true
pin "imagesloaded.pkgd.min", to: "imagesloaded.pkgd.min.js", preload: true
pin "isotope.pkgd.min", to: "isotope.pkgd.min.js", preload: true
pin "jquery.appear", to: "jquery.appear.js", preload: true
pin "jquery.magnific-popup.min", to: "jquery.magnific-popup.min.js", preload: true
pin "jquery.odometer.min", to: "jquery.odometer.min.js", preload: true
pin "main", to: "main.js", preload: true
pin "select2.min", to: "select2.min.js", preload: true
pin "slick-animation.min", to: "slick-animation.min.js", preload: true
pin "slick.min", to: "slick.min.js", preload: true
pin "tg-cursor.min", to: "tg-cursor.min.js", preload: true
pin "tween-max.min", to: "tween-max.min.js", preload: true
pin "vivus.min", to: "vivus.min.js", preload: true
pin "wow.min", to: "wow.min.js", preload: true
