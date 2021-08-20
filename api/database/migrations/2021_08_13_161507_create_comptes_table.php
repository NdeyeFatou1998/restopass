<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateComptesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('comptes', function (Blueprint $table) {
            $table->id();
            $table->string("account_num")->unique();
            $table->unsignedBigInteger("pay")->default(0);
            $table->unsignedBigInteger("debt")->default(0);
            $table->boolean("status")->default(true);
            $table->string("account_code")->unique();
            $table->string("pin")->nullable();
            $table->foreignId("user_id")->unique()->index();
            $table->foreign("user_id")->references("id")->on("users");

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
        Schema::dropIfExists('comptes');
    }
}
