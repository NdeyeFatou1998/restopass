@component('mail::message')
# Resto Pass,

Bonjour {{ $user->first_name }},
Vous avez fait une demande de réinitialisation de votre code pin.
@component('mail::panel')
- Votre code pin est : {{ $pin }}
@endcomponent

Merci,<br>
{{ config('app.name') }}
@endcomponent
