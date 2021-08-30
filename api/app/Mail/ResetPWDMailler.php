<?php

namespace App\Mail;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class ResetPWDMailler extends Mailable
{
    use Queueable, SerializesModels;
    public User $user;
    public $code;
    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct(User $user, $code)
    {
        $this->user = $user;
        $this->code = $code;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->from('resto.pass@iris.sn')
            ->markdown('emails.resetPassword', [
                'user' => $this->user,
                'code' => $this->code
            ]);
    }
}
