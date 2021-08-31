@component('mail::message')
# Resto Pass,<br/>

Bonjour {{ $user->first_name }},
Vous avez fait une demande de réinitialisation de mot de passe.
Merci d'utiliser cette code de vérification pour modifier votre mot de passe.
@component('mail::panel')
- Code de vérification : {{ $code }}
@endcomponent

Merci,<br>
{{ config('app.name') }}
@endcomponent
