<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateRechargementsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('rechargements', function (Blueprint $table) {
            $table->id();
            $table->string("transaction_num")->unique();
            $table->unsignedInteger("amount");
            $table->string("phone_number");
            $table->string("via");

            $table->foreignId("compte_id")->unique()->index();
            $table->foreign("compte_id")->references("id")->on("comptes");

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
        Schema::dropIfExists('rechargements');
    }
}
