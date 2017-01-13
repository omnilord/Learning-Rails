$(function () {
  $(document).on('click', '.toggling-forms-parent a.toggle-form', function (ev) {
    ev.preventDefault();
    var $this = $(this),
        $forms = $this.closest('.toggling-forms-parent').find('.toggling-form'),
        $active = $forms.filter(':not(.invis)'),
        search = $this.data('searchfor'),
        moving;

    if (search != $active.data('searchfor')) {
      $active = $forms.toggleClass('invis', true).filter('[data-searchfor="' + search + '"]').removeClass('invis');
      $this.addClass('marked').closest('li').siblings().find('a.toggle-form').removeClass('marked');
      moving = $this.closest('.btn-group').find('button.dropdown-toggle, ul.dropdown-menu').remove();
      moving.filter('button.dropdown-toggle').find('i').replaceWith($this.find('i').clone());
      $active.find('.btn-group').append(moving);
    }
  });
});
