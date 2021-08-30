<?php

namespace App\Mail;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class ResetPinMailler extends Mailable
{
    use Queueable, SerializesModels;
    public User $user;
    public $pin;
    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct(User $user, $pin)
    {
        $this->user = $user;
        $this->pin = $pin;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->from('resto.pass@iris.sn')
            ->markdown('emails.resetPin', ['user' => $this->user, 'pin' => $this->pin]);
    }
}
