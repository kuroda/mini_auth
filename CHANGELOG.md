## 0.3.0

* Add the class method `token` that defines "generate_#{name}_token" and
  "verify_#{name}_token" methods dynamically.
* Remove the deprecation warnings in Rails 3.2.0.rc1
* Unset `changing_password` and `setting_password` after the object is saved.

## 0.2.0 (2011-12-19)

* Two attributes `changing_password` and `setting_password` are introduced.
* When `changing_password` is set to `true`, users should enter `current_password`
  and `new_password` to change their password. If they enter wrong `current_passwod`,
  validation on `current_password` fails.
* When `setting_password` is set to `true`, users should enter not-blank `password`.
  Unlike the version 0.1.0, nil password is not accepted.
* When neither of these two attributes is set to `true`, users can't set or change
  their password. If the `password` parameter is passed to the object,
  it is neglected and all validations relating password are skipped.
* Besides, two attributes `password_confirmation` and `new_password_confirmation`
  are added.

## 0.1.0 (2011-12-13)

* The `authenticate` method returns `self` instead of `true`

## 0.1.0.pre2 (2011-12-13)

* The `password_digest` field is protected against mass-assignment

## 0.1.0.pre (2011-12-13)

* MiniAuth#authenticate is implemented using BCrypt::Password
* Password should not be blank string but can be nil 
* First public release as a gem
