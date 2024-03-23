;;; lsp-standard-ruby.el --- lsp-mode for Standard Ruby  -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Cédric Delalande

;; Author: Cédric Delalande <contact@moskitohero.com>
;; Keywords: lsp, ruby, languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; LSP client for Standard Ruby which is an opinonated Ruby static code analyzer (a.k.a. linter)
;; and code formatter based on RuboCop.

;;; Code:

(require 'lsp-mode)

(defgroup lsp-standard-ruby nil
  "LSP support for Standard Ruby, using the Standard Ruby built-in language server."
  :group 'lsp-mode
  :link '(url-link "https://github.com/standardrb/standard")
  :package-version '(lsp-mode . "8.0.1"))

(defcustom lsp-standard-ruby-use-bundler nil
  "Run Standard Ruby using Bundler."
  :type 'boolean
  :safe #'booleanp
  :group 'lsp-standard-ruby
  :package-version '(lsp-mode . "8.0.1"))

(defcustom lsp-standard-ruby-as-add-on t
  "Run standard ruby LSP server alongside other LSP server(s)"
  :type 'boolean
  :group 'lsp-standard-ruby
  :package-version '(lsp-mode . "8.0.0"))

(defcustom lsp-standard-ruby-server-path nil
  "Path of the Standard Ruby built-in language server executable.
If specified, `lsp-standard-ruby-use-bundler' is ignored."
  :type 'file
  :group 'lsp-standard-ruby
  :package-version '(lsp-mode . "8.0.1"))

(defun lsp-standard-ruby--build-command ()
  "Build a command to start the Standard Ruby built-in language server."
  (append
   (if (and lsp-standard-ruby-use-bundler (not lsp-standard-ruby-server-path)) '("bundle" "exec"))
   (list (or lsp-standard-ruby-server-path "standardrb") "--lsp")))

(lsp-register-client
 (make-lsp-client
  :add-on? lsp-standard-ruby-as-add-on
  :new-connection (lsp-stdio-connection #'lsp-standard-ruby--build-command)
  :activation-fn (lsp-activate-on "ruby")
  :server-id 'standard-ruby-ls))

(lsp-consistency-check lsp-standard-ruby)

(provide 'lsp-standard-ruby)
;;; lsp-standard-ruby.el ends here
