<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateTransfertsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('transferts', function (Blueprint $table) {
            $table->id();
            $table->unsignedInteger("amount");

            $table->foreignId("from_id")->index();
            $table->foreign("from_id")->references("id")->on("comptes");

            $table->foreignId("to_id")->index();
            $table->foreign("to_id")->references("id")->on("comptes");

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
        Schema::dropIfExists('transferts');
    }
}
