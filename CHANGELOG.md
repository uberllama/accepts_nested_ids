## 0.2.2 (2021-02-04)

Ensure this works with Ruby 3.0.0 by adding the #attribute method within any class to extend ActiveRecord in order to create those helper methods.

## 0.2.1 (2016-02-05)

Ensure empty array of nested associations is loaded, to handle situations where a sub class does not define its own associations and the intersection between base and sub class associations was failing.

## 0.2.0 (2016-02-05)

Fix for associations defined on a subclass not being saved.

## 0.1.2 (2015-08-12)

Fix for STI.
