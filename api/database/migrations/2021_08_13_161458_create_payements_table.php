<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePayementsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('payements', function (Blueprint $table) {
            $table->id();
            $table->dateTime("date_time");

            $table->foreignId("resto_id");
            $table->foreign("resto_id")->references("id")->on("restos");

            $table->foreignId("vigil_id");
            $table->foreign("vigil_id")->references("id")->on("vigils");

            $table->foreignId("user_id")->index();
            $table->foreign("user_id")->references("id")->on("users");

            $table->foreignId("tarif_id");
            $table->foreign("tarif_id")->references("id")->on("tarifs");

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('payements');
    }
}
