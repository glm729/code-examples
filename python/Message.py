#!/usr/bin/env python3


# Class definition
# -----------------------------------------------------------------------------


class Message:
    """
    Print a somewhat-formatted message.  Class version permits building the
    text then using it directly, instead of printing.  Also gives more control
    over the behaviour or modification of the instance.
    """

    def __init__(self, text, form=None):
        """
        Store the forms of the message, store the text, and store and set the
        form if entered.
        """
        # Store the currently available forms
        self.forms = {
            "exit": "\033[7;31m EXIT \033[0m",
            "ok": "\033[7;32m  OK  \033[0m",
            "warn": "\033[7;33m WARN \033[0m",
            "info": "\033[7;34m INFO \033[0m",
            "input": "\033[7;35m  IP  \033[0m",
            "data": "\033[7;36m DATA \033[0m",
        }
        # Store the current text and form
        self._text = text
        self._form = form
        # Set the form if it's been specified
        if bool(form):
            self.set_form(form)

    def set_form(self, form):
        """
        Set the form and rebuild the text, if the form is available.
        """
        # If the form is valid, store it, and build the text
        if (f := self.forms.get(form, None)) is not None:
            self._form = form
            self.build()
            return
        # Available form keys
        _keys = ", ".join(self.forms.keys())
        # RuntimeError message
        _remsg = f"Form {form} not found; Available keys: {_keys}"
        # Raise the error according to the message / form
        raise RuntimeError(_remsg)

    def set_text(self, text):
        """
        Set the text, and, if the form is set, rebuild the text.
        """
        # Store the message text
        self._text = text
        # If there's a valid form, rebuild
        if bool(self._form):
            self.build()

    def build(self):
        """
        Build the final text to output.
        """
        # Text template to use
        t = "%(form)s %(text)s"
        # Set the text
        self.text = t % {"form": self.forms[self._form], "text": self._text}

    def print(self):
        """
        Print the message to the console.
        """
        if bool(self._form):
            print(self.text)
            return
        print(self._text)


# Example usage
# -----------------------------------------------------------------------------


if __name__ == "__main__":
    # Initialise with text and form
    msg = Message("Hello!", form="info")
    # On second thoughts, change the form
    msg.set_form("ok")
    # Maybe change the text too
    msg.set_text("Hello again!")
    # Print it now, before I change my mind again!
    msg.print()
    # Quick print the same
    Message("Hello again", form="ok").print()
    # Or get the text
    some_other_var = msg.text
