<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class IsInResto
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle(Request $request, Closure $next)
    {
        $vigil = auth()->user();
        if($vigil->resto_id == null){
            return response()->json([
                'message' => 'Vous n\'est affecter à aucun resto.',
                'code' => 401
            ]);
        }
        return $next($request);
    }
}
