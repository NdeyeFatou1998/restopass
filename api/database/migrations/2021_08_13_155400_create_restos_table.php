<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateRestosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('restos', function (Blueprint $table) {
            $table->id();
            $table->string("name");
            $table->integer("capacity")->default(0);
            $table->string("image_path")->nullable();

            $table->unsignedBigInteger("universite_id");
            $table->foreign("universite_id")->references("id")->on("universites");

            $table->unsignedBigInteger("repreneur_id")->nullable();
            $table->foreign("repreneur_id")->references("id")->on("admins");

            $table->unsignedBigInteger("menu_id")->nullable();
            $table->foreign("menu_id")->references("id")->on("menus");
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
        Schema::dropIfExists('restos');
    }
}
