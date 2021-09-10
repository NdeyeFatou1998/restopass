<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AltColumnVigilFromRestosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('restos', function (Blueprint $table) {
            $table->foreign("universite_id")->references("id")->on("universites")->onDelete('set null');

            $table->foreign("repreneur_id")->references("id")->on("admins")->onDelete('set null');

            $table->foreign("menu_id")->references("id")->on("menus")->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('restos', function (Blueprint $table) {
            //
        });
    }
}
